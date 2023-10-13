import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/reals.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserData() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String password,
    required String email,
    required String username,
    //required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (password.isNotEmpty && email.isNotEmpty && username.isNotEmpty) {
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        //print(userCred.user!.uid);

        String photoURL = await StorageMethods().uploadImageToSotarage(
          'ProfilePic',
          file,
          false,
        );

        model.User newUser = model.User(
          email: email,
          username: username,
          followers: [],
          following: [],
          uid: userCred.user!.uid,
          photoURL: photoURL,
          dataCreated: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(userCred.user!.uid)
            .set(newUser.toJson());

        res = "Success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = "Invalid email address";
      } else if (err.code == 'weak-password') {
        res = "Invalid password";
      } else if (err.code == 'email-already-in-use') {
        res = "Email already in use";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  ///////////////////////////////////////////////////////////////////////////////////

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "Success";
      } else {
        res = "Please enter all the fileds";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "wrong-password") {
        res = "Wrong password";
      } else if (err.code == "user-not-found") {
        res = "User not found";
      } else if (err.code == "invalid-email") {
        res = "Invalid email address";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  ////////////////////////////////////////////////////////////////////////////

  upladVideo(
    String songName,
    String caption,
    String videoPath,
  ) async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection("users").doc(uid).get();

      var allVideos = await _firestore.collection("videos").get();
      int len = allVideos.docs.length;

      String videoURL =
          await StorageMethods().uploadVideoToStroage("Video $len", videoPath);

      String thumbNailURL = await StorageMethods()
          .uploadThumbNailToStroage("Video $len", videoPath);

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['username'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoURL: videoURL,
        videoThumbNail: thumbNailURL,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['photoURL'],
      );

      await _firestore
          .collection("videos")
          .doc("Video $len")
          .set(video.toJson());
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  ////////////////////////////////////////////////////////////////////////////

  Future<String> uploadPost({
    required String description,
    required Uint8List file,
    required String uid,
    required String username,
    required String profImage,
  }) async {
    String res = "Some error occurred";
    try {
      String photoURL =
          await StorageMethods().uploadImageToSotarage('posts', file, true);

      String id = const Uuid().v1();

      Post post = Post(
        description: description,
        username: username,
        postID: id,
        datePublished: DateTime.now(),
        uid: uid,
        profImage: profImage,
        postURL: photoURL,
        likes: [],
        saves: [],
      );

      _firestore.collection('posts').doc(id).set(
            post.toJson(),
          );
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  ////////////////////////////////////////////////////////////////////////////////

  Future<void> savePost(String postID, String uid, List saves) async {
    try {
      if (saves.contains(uid)) {
        await _firestore.collection('posts').doc(postID).update({
          'saves': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postID).update({
          'saves': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /////////////////////////////////////////////////////////////////////////////////

  Future<void> likePost(
      String postID, String uid, List likes, bool smallLike) async {
    try {
      if (likes.contains(uid)) {
        if (smallLike) {
          await _firestore.collection('posts').doc(postID).update({
            'likes': FieldValue.arrayRemove([uid])
          });
        }
      } else {
        await _firestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

  Future<void> likeComment(
    String postID,
    String uid,
    String commentID,
    List likes,
  ) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection("posts")
            .doc(postID)
            .collection("comments")
            .doc(commentID)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection("posts")
            .doc(postID)
            .collection("comments")
            .doc(commentID)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  /////////////////////////////////////////////////////////////////////////////////

  Future<void> postComment(
    String postID,
    String text,
    String uid,
    String username,
    String profImage,
  ) async {
    try {
      String id = const Uuid().v1();
      Comment comment = Comment(
        postID: postID,
        uid: uid,
        text: text,
        username: username,
        profImage: profImage,
        datePublished: DateTime.now(),
        commentID: id,
        likes: [],
      );

      if (text.isNotEmpty) {
        _firestore
            .collection('posts')
            .doc(postID)
            .collection('comments')
            .doc(id)
            .set(
              comment.toJson(),
            );
      } else {
        print(
          "Text is empty",
        );
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////

  Future<void> deletePost(String postID) async {
    try {
      await _firestore.collection('posts').doc(postID).delete();
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////

  Future<void> followUser(
    String uid,
    String followID,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followID)) {
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followID])
        });
      } else {
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followID])
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////

  Future<void> sigOut() async {
    await _auth.signOut();
    SystemNavigator.pop();
  }
}
