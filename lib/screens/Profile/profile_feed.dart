import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/widgets/post_info_screen.dart';

// ignore: must_be_immutable
class ProfilePostFeed extends StatefulWidget {
  final String uid;
  final bool grid;
  final Future futureArgument;
  bool postData;

  ProfilePostFeed({
    super.key,
    required this.uid,
    required this.grid,
    required this.futureArgument,
    required this.postData,
  });

  @override
  State<ProfilePostFeed> createState() => _ProfilePostFeedState();
}

class _ProfilePostFeedState extends State<ProfilePostFeed> {
  int postIndex = 0;

  @override
  Widget build(BuildContext context) {
    return widget.postData == false
        ? Expanded(
            child: FutureBuilder(
              future: widget.futureArgument,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return widget.grid == false
                    ? Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              bottom: 7,
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  'Grid view',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'tap for information',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: GridView.custom(
                              gridDelegate: SliverQuiltedGridDelegate(
                                crossAxisCount: 3,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                repeatPattern:
                                    QuiltedGridRepeatPattern.inverted,
                                pattern: [
                                  const QuiltedGridTile(1, 1),
                                  const QuiltedGridTile(1, 1),
                                  const QuiltedGridTile(1, 1),
                                ],
                              ),
                              childrenDelegate: SliverChildBuilderDelegate(
                                (context, index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.postData = true;
                                      postIndex = index;
                                    });
                                  },
                                  child: SizedBox(
                                    child: Image.network(
                                      (snapshot.data! as dynamic).docs[index]
                                          ['postURL'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                childCount:
                                    (snapshot.data! as dynamic).docs.length,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              bottom: 7,
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  'Slide view',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: PageView.builder(
                              itemCount: snapshot.data!.docs.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => PostInfo(
                                post: (snapshot.data! as dynamic).docs[index],
                                isPost: false,
                                list: false,
                                picture: (snapshot.data! as dynamic).docs[index]['postURL'],
                              ),
                            ),
                          ),
                        ],
                      );
              },
            ),
          )
        : Expanded(
            child: FutureBuilder(
              future: widget.futureArgument,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      widget.postData = false;
                    });
                  },
                  child: PostInfo(
                    post: (snapshot.data! as dynamic).docs[postIndex],
                    isPost: false,
                    list: true,
                    picture: (snapshot.data! as dynamic).docs[postIndex]['postURL']
                  ),
                );
              },
            ),
          );
  }
}
