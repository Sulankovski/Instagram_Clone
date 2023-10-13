import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/log_in_screen.dart';
import 'package:instagram_clone/screens/Profile/profile_feed.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  var postLen = 0;
  var followersLen = 0;
  var followingLen = 0;
  bool isFollowing = false;
  bool isLoading = false;
  int _page = 0;

  bool posts = true;
  bool postsGrid = false;
  bool liked = false;
  bool likedGrid = false;
  bool saved = false;
  bool savedGrid = false;

  bool data = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      userData = userSnap.data()!;
      postLen = postSnap.docs.length;
      followersLen = userData['followers'].length;
      followingLen = userData['following'].length;
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
      _page == 0
          ? {
              posts = true,
              liked = false,
              saved = false,
              data = false,
            }
          : _page == 1
              ? {
                  posts = false,
                  liked = true,
                  saved = false,
                  data = false,
                }
              : {
                  posts = false,
                  liked = false,
                  saved = true,
                  data = false,
                };
    });
    print(_page);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'],
              ),
              centerTitle: false,
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 210,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                userData['photoURL'],
                              ),
                              radius: 40,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStats("posts", postLen),
                                      buildStats("followers", followersLen),
                                      buildStats("following", followingLen)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.uid
                                          ? FollowButton(
                                              backgroundColor:
                                                  Color.fromARGB(255, 93, 93, 93),
                                              borderColor: Colors.grey,
                                              text: 'Sign Out',
                                              textColor: primaryColor,
                                              function: () async {
                                                await AuthMethods().sigOut();
                                                // ignore: use_build_context_synchronously
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LogInScreen(),
                                                  ),
                                                );
                                              },
                                            )
                                          : isFollowing
                                              ? FollowButton(
                                                  backgroundColor: Color.fromARGB(255, 93, 93, 93),
                                                  borderColor: Colors.grey,
                                                  text: 'Unfollow',
                                                  textColor: Colors.black,
                                                  function: () async {
                                                    await AuthMethods()
                                                        .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid'],
                                                    );
                                                    setState(() {
                                                      isFollowing = false;
                                                      followersLen--;
                                                    });
                                                  },
                                                )
                                              : FollowButton(
                                                  backgroundColor: Colors.blue,
                                                  borderColor: Colors.blue,
                                                  text: 'Follow',
                                                  textColor: Colors.black,
                                                  function: () async {
                                                    await AuthMethods()
                                                        .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid'],
                                                    );
                                                    setState(() {
                                                      isFollowing = true;
                                                      followersLen++;
                                                    });
                                                  },
                                                ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 5,
                              ),
                              child: Text(
                                userData['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: PageView(
                                controller: PageController(
                                  viewportFraction: 0.5,
                                ),
                                onPageChanged: onPageChange,
                                children: [
                                  Column(
                                    children: [
                                      Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              "Posts",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 15,
                                                color: posts == true
                                                    ? blueColor
                                                    : primaryColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  postsGrid == true
                                                      ? postsGrid = false
                                                      : postsGrid = true;
                                                });
                                              },
                                              child: Icon(
                                                postsGrid == false
                                                    ? Icons.apps_outlined
                                                    : Icons
                                                        .amp_stories_outlined,
                                                color: posts == true
                                                    ? blueColor
                                                    : primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              "Liked Posts",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 15,
                                                color: liked == true
                                                    ? blueColor
                                                    : primaryColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  likedGrid == true
                                                      ? likedGrid = false
                                                      : likedGrid = true;
                                                });
                                              },
                                              child: Icon(
                                                likedGrid == false
                                                    ? Icons.apps_outlined
                                                    : Icons
                                                        .amp_stories_outlined,
                                                color: liked == true
                                                    ? blueColor
                                                    : primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              "Saved Posts",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 15,
                                                color: saved == true
                                                    ? blueColor
                                                    : primaryColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  savedGrid == true
                                                      ? savedGrid = false
                                                      : savedGrid = true;
                                                });
                                              },
                                              child: Icon(
                                                savedGrid == false
                                                    ? Icons.apps_outlined
                                                    : Icons
                                                        .amp_stories_outlined,
                                                color: saved == true
                                                    ? blueColor
                                                    : primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                top: 7,
                              ),
                              height: 20,
                              width: double.infinity,
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 2,
                                decoration: const BoxDecoration(
                                  color: secondaryColor
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                isFollowing == true ||
                        widget.uid == FirebaseAuth.instance.currentUser!.uid
                    ? posts == true
                        ? ProfilePostFeed(
                            uid: widget.uid,
                            grid: postsGrid,
                            postData: data,
                            futureArgument: FirebaseFirestore.instance
                                .collection('posts')
                                .where('uid', isEqualTo: widget.uid)
                                .get(),
                          )
                        : liked == true
                            ? ProfilePostFeed(
                                uid: widget.uid,
                                grid: likedGrid,
                                postData: data,
                                futureArgument: FirebaseFirestore.instance
                                    .collection('posts')
                                    .where('likes', arrayContains: widget.uid)
                                    .get(),
                              )
                            : ProfilePostFeed(
                                uid: widget.uid,
                                grid: savedGrid,
                                postData: data,
                                futureArgument: FirebaseFirestore.instance
                                    .collection('posts')
                                    .where('saves', arrayContains: widget.uid)
                                    .get(),
                              )
                    : Center(
                        child: Text(
                            'You need to be following ${userData['username']} for this section'),
                      ),
              ],
            ),
          );
  }

  Column buildStats(String label, int num) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 4,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w300,
            ),
          ),
        )
      ],
    );
  }
}
