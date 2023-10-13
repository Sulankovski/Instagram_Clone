import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/screens/Profile/profile_screen.dart';
import 'package:instagram_clone/screens/likes_screen.dart';
import 'package:instagram_clone/widgets/animation.dart';
import 'package:instagram_clone/widgets/picture_box.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  Widget commentsLen = Text('');

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() {
    commentsLen = StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap['postID'])
            .collection('comments')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data!.docs.isNotEmpty
              ? Text(
                  "View all ${snapshot.data!.docs.length} comments",
                )
              : const Text(
                  "Be the first to comment",
                );
        });
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(
      ClipboardData(
        text: widget.snap['profImage'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16).copyWith(right: 0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    uid: widget.snap['uid'],
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      widget.snap['profImage'],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: const Center(
                              child: Text(
                                'Options',
                              ),
                            ),
                            backgroundColor: mobileBackgroundColor,
                            children: [
                              user!.uid == widget.snap['uid']
                                  ? TextButton(
                                      onPressed: () async {
                                        AuthMethods().deletePost(
                                          widget.snap['postID'],
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 11),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              TextButton(
                                onPressed: () async {
                                  _copyToClipboard(context);
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 11),
                                  child: const Text(
                                    "Get post URL",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await AuthMethods().likePost(
                widget.snap['postID'],
                user!.uid,
                widget.snap['likes'],
                false,
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: PictureBox(
                    picture: widget.snap["postURL"],
                    height: 0.5,
                    width: 0.5,
                    ispost: true,
                    fit: BoxFit.contain,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: BuildAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              BuildAnimation(
                isAnimating: widget.snap['likes'].contains(user!.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    widget.snap['likes'].contains(user.uid)
                        ? isLikeAnimating = false
                        : isLikeAnimating = true;
                    await AuthMethods().likePost(
                      widget.snap['postID'],
                      user.uid,
                      widget.snap['likes'],
                      true,
                    );
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(
                      snap: widget.snap,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () async {
                      await AuthMethods().savePost(
                        widget.snap['postID'],
                        user.uid,
                        widget.snap['saves'],
                      );
                    },
                    icon: widget.snap['saves'].contains(user.uid)
                        ? const Icon(
                            Icons.bookmark_remove,
                          )
                        : const Icon(
                            Icons.bookmark_add_outlined,
                          ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LikesScreen(
                          streamLikes: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.snap['postID'])
                              .get(),
                          snap: widget.snap,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    '${widget.snap["likes"].length} likes',
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snap["username"],
                          ),
                          TextSpan(
                            text: '  ${widget.snap["description"]}',
                          )
                        ]),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(
                      snap: widget.snap,
                    ),
                  ),
                ),
                child: Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    // width: double.infinity,
                    child: commentsLen),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              child: Text(
                DateFormat.yMMMd().format(
                  widget.snap["datePublished"].toDate(),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
            child: Container(
              margin: const EdgeInsets.only(top: 18, left: 16, right: 16),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 72, 72, 72),
                  borderRadius: BorderRadius.circular(3)),
            ),
          )
        ],
      ),
    );
  }
}
