import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/widgets/comments_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({
    super.key,
    required this.snap,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _text = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  bool _inUse = false;

  @override
  void dispose() {
    super.dispose();
    _text.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          "Comments",
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postID'])
            .collection('comments')
            .orderBy(
              'datePublished',
              descending: true,
            )
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          // ***
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs
                .length, //(snapshot.data! as dynamic).docs.length, ako ne se smecificira tipot ***
            itemBuilder: (context, index) => CommentCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user!.photoURL,
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 8,
                  ),
                  child: Focus(
                    focusNode: _textFieldFocusNode,
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                        setState(
                          () {
                            _inUse = true;
                          },
                        );
                      } else {
                        setState(
                          () {
                            _inUse = false;
                          },
                        );
                      }
                    },
                    child: TextField(
                      controller: _text,
                      decoration: InputDecoration(
                        hintText: 'Comment as ${user.username}',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await AuthMethods().postComment(
                    widget.snap['postID'],
                    _text.text,
                    user.uid,
                    user.username,
                    user.photoURL,
                  );
                  setState(
                    () {
                      _text.clear();
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    right: 8,
                  ),
                  child: _inUse == true
                      ? const Icon(
                          Icons.arrow_upward,
                        )
                      : const Icon(
                          Icons.arrow_back_rounded,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
