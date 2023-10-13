import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/screens/Profile/profile_screen.dart';
import 'package:instagram_clone/widgets/picture_box.dart';
import 'package:instagram_clone/widgets/post_info_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isUsersubmited = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Container(
          padding: const EdgeInsets.only(
            top: 5,
            left: 16,
            right: 8,
          ),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[700], // Set the background color here
            borderRadius:
                BorderRadius.circular(10.0), // Optional: Add rounded corners
          ),
          child: TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Search for user',
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                _isUsersubmited = true;
              });
            },
          ),
        ),
      ),
      body: _isUsersubmited == true && _controller.text != ''
          ? FutureBuilder(
              future: _firestore
                  .collection('users')
                  .where(
                    'username',
                    isEqualTo: _controller.text,
                  )
                  .get(),
              builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length, //(snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 8,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uid: snapshot.data!.docs[index]['uid'],
                                // uid: (snapshot.data! as dynamic).docs[index]
                                //     ['uid'],
                              ),
                            ),
                          );
                          _controller.clear();
                          setState(() {
                            _isUsersubmited = false;
                          });
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              (snapshot.data! as dynamic).docs[index]
                                  ['photoURL'],
                            ),
                          ),
                          title: Text((snapshot.data! as dynamic).docs[index]
                              ['username']),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : StreamBuilder(
              stream: _firestore.collection('posts').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return GridView.custom(
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    repeatPattern: QuiltedGridRepeatPattern.inverted,
                    pattern: [
                      const QuiltedGridTile(1, 1),
                      const QuiltedGridTile(1, 1),
                      const QuiltedGridTile(2, 1),
                      const QuiltedGridTile(1, 1),
                      const QuiltedGridTile(1, 1),
                    ],
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) => SizedBox(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  backgroundColor: mobileBackgroundColor,
                                  title: const Text("Post info"),
                                ),
                                body: PostInfo(
                                  post: (snapshot.data! as dynamic).docs[index],
                                  isPost: true,
                                  list: false,
                                  picture: (snapshot.data! as dynamic).docs[index]['postURL'],
                                ),
                              ),
                            ),
                          );
                        },
                        child: PictureBox(
                          picture: (snapshot.data! as dynamic).docs[index]
                              ['postURL'],
                          height: 1,
                          width: 1,
                          ispost: true,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    childCount: (snapshot.data! as dynamic).docs.length,
                  ),
                );
              },
            ),
    );
  }
}
