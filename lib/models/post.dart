import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String description;
  final String postID;
  final datePublished;
  final String uid;
  final String postURL;
  final String profImage;
  final likes;
  final saves;

  const Post({
    required this.description,
    required this.username,
    required this.postID,
    required this.datePublished,
    required this.uid,
    required this.profImage,
    required this.postURL,
    required this.likes,
    required this.saves,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "datePublished": datePublished,
        "profImage": profImage,
        "postID": postID,
        "postURL": postURL,        
        "likes": likes,
        "saves": saves,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      postID: snapshot['postID'],
      postURL: snapshot['postURL'],
      likes: snapshot['likes'],
      saves: snapshot['saves'],
    );
  }
}
