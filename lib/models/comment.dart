import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
    final String postID;
    final String text;
    final String uid;
    final String username;
    final String profImage;
    final datePublished;
    final String commentID;
    final likes;

  const Comment({
    required this.postID,
    required this.uid,
    required this.text,
    required this.username,
    required this.profImage,
    required this.datePublished,
    required this.commentID,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "text": text,
        "datePublished": datePublished,
        "profImage": profImage,
        "postID": postID,
        "commentID": commentID,
        "likes": likes,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      username: snapshot['username'],
      uid: snapshot['uid'],
      text: snapshot['text'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      postID: snapshot['postID'],
      commentID: snapshot['commentID'],
      likes: snapshot['likes'],
    );
  }
}
