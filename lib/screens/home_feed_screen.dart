import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/colors.dart';
// import 'package:instagram_clone/models/user.dart' as model;
// import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/widgets/picture_box.dart';
import 'package:instagram_clone/widgets/post_card.dart';
// import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    // final model.User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: const PictureBox(
          picture: 'assets/Instagram_logo_name.jpg',
          height: 0.3,
          width: 0.33,
          ispost: false,
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.message_outlined,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .orderBy(
              'datePublished',
              descending: true,
            )
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
          // return ListView.builder(
          //   itemCount: snapshot.data!.docs.length,
          //   itemBuilder: (context, index) => user!.following
          //               .contains(snapshot.data!.docs[index].data()['uid']) ||
          //           user.uid == snapshot.data!.docs[index].data()['uid']
          //       ? PostCard(
          //           snap: snapshot.data!.docs[index].data(),
          //         )
          //       : Container(),
          // );
        },
      ),
    );
  }
}
