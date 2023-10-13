import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/Profile/profile_screen.dart';
import 'package:instagram_clone/screens/likes_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({
    super.key,
    required this.snap,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.only(
        left: 12,
        right: 10,
        bottom: 20,
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 60,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 72, 72, 72),
                borderRadius: BorderRadius.circular(3)),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  uid: widget.snap['uid'],
                ),
              ),
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.snap['profImage']),
              radius: 18,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.snap['username']}  ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.snap['text'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () async {
                await AuthMethods().likeComment(
                  widget.snap['postID'],
                  user.uid,
                  widget.snap['commentID'],
                  widget.snap['likes'],
                );
              },
              child: Column(
                children: [
                  widget.snap['likes'].contains(user!.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 16,
                        )
                      : const Icon(
                          Icons.favorite_border_outlined,
                          size: 16,
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  widget.snap['likes'].isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LikesScreen(
                                  streamLikes: FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(widget.snap['postID'])
                                      .collection('comments')
                                      .doc(widget.snap['commentID'])
                                      .get(),
                                  snap: widget.snap,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            widget.snap['likes'].length.toString(),
                            style: const TextStyle(
                                color: secondaryColor, fontSize: 10),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
