import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String email;
  final List followers;
  final List following;
  final String uid;
  final String photoURL;
  final dataCreated;

  const User({
    this.dataCreated, 
    required this.email,
    required this.username,
    required this.followers,
    required this.following,
    required this.uid,
    required this.photoURL,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "followers": followers,
        "following": following,
        "uid": uid,
        "photoURL": photoURL,
        "dataCreated": dataCreated,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'],
      username: snapshot['username'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      uid: snapshot['uid'],
      photoURL: snapshot['photoURL'],
      dataCreated: snapshot['dataCreated']
    );
  }
}
