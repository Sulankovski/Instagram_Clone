import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/widgets/picture_box.dart';
import 'package:intl/intl.dart';

class PostInfo extends StatefulWidget {
  final String picture;
  final dynamic post;
  final bool isPost;
  final bool list;

  const PostInfo({
    super.key,
    required this.post,
    required this.isPost,
    required this.list,
    required this.picture,
  });

  @override
  State<PostInfo> createState() => _PostInfoState();
}

class _PostInfoState extends State<PostInfo> {
  var userStats = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.post['uid'])
          .get();
      setState(() {
        userStats = snap.data()!;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.list == true
            ? Container(
                padding: const EdgeInsets.only(
                  bottom: 7,
                ),
                child: const Column(
                  children: [
                    Text(
                      'Post Information',
                      style: TextStyle(
                        fontSize: 20,
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'double tap to exit',
                      style: TextStyle(
                        fontSize: 10,
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        Expanded(
          child: SizedBox(
            child: PageView(
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    //color: Colors.amber,
                    child: PictureBox(
                      picture: widget.post['postURL'],
                      height: 1,
                      width: 1,
                      ispost: true,
                      fit: widget.isPost == false
                          ? BoxFit.cover
                          : BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 150),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        stats(
                          "Username",
                          widget.post['username'],
                        ),
                        stats(
                          "Email",
                          userStats['email'].toString(),
                        ),
                        stats(
                          "Date published",
                          DateFormat.yMMMd().format(
                            widget.post["datePublished"].toDate(),
                          ),
                        ),
                        stats(
                          "Description",
                          widget.post["description"].toString() == ''
                              ? '  -  -  -  -  -  -  '
                              : widget.post["description"],
                        ),
                        stats(
                          "Likes",
                          widget.post['likes'].length.toString(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 70,
                                width: 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: secondaryColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      appBar: AppBar(
                                        backgroundColor: mobileBackgroundColor,
                                      ),
                                      body: PictureBox(
                                        picture: widget.post["postURL"],
                                        height: 1,
                                        width: 1,
                                        ispost: true,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      bottom: 25,
                                    ),
                                    child: Text(
                                      "View post full screen",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding stats(String stat, var statValue) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: secondaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 25,
                  ),
                  child: Text(
                    stat,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 25,
                  ),
                  child: Text(
                    statValue,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
