import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/screens/Profile/profile_screen.dart';

class LikesScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  final isComment;
  final Future streamLikes;
  const LikesScreen({
    super.key,
    required this.streamLikes,
    required this.snap,
    this.isComment,
  });

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  String userName = '';
  String profilePic = '';
  List<String?> usernames = [];
  List<String?> userProfilePic = [];
  List<String?> userUID = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {}

  Future<List<String?>> fetchUsernamesForUids(List<dynamic> uids) async {
    for (String uid in uids) {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (userSnapshot.exists) {
        var username = userSnapshot['username'];
        var userPic = userSnapshot['photoURL'];
        var useruid = userSnapshot['uid'];
        usernames.add(username);
        userProfilePic.add(userPic);
        userUID.add(useruid);
      } else {
        usernames.add(null); // Handle the case when the document doesn't exist
      }
    }

    return usernames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          widget.isComment == false 
          ? "Likes on ${widget.snap['username']}'s posts"
          : "Likes on ${widget.snap['username']}'s comment",
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: FutureBuilder(
        future: widget.streamLikes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<dynamic> stringArray = snapshot.data['likes'];

          return FutureBuilder(
            future: fetchUsernamesForUids(stringArray),
            builder: (context, usernamesSnapshot) {
              if (usernamesSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<String?> usernames = usernamesSnapshot.data as List<String?>;

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: stringArray.length,
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 10,
                    bottom: 20,
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          uid: userUID[index] ?? '',
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 3,
                          height: 60,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 72, 72, 72),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(userProfilePic[index] ?? ''),
                          radius: 18,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                            ),
                            child: Text(
                              usernames[index] ?? 'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
