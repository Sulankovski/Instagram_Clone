import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

class StorageMethods{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToSotarage(String childname, Uint8List file, bool isPost) async {
    
    Reference ref = _storage.ref().child(childname).child(_auth.currentUser!.uid);

    if(isPost){
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;

    String downloadURL = await snap.ref.getDownloadURL();

    return downloadURL;
  }

  ///////////////////////////////////////////////////////////////////////

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }
  Future<String> uploadVideoToStroage(String id, String videoPath) async {
    Reference ref = _storage.ref().child("videos").child(id);

    UploadTask uploadTask = ref.putFile(
      await _compressVideo(videoPath),
    );
    TaskSnapshot snap = await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
  }

  //////////////////////////////////////////////////////////////////////////

  _getThumbNail(String videoPath) async {
    final thumbNail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbNail;
  }
  Future<String> uploadThumbNailToStroage(String id, String videoPath) async {
    Reference ref = _storage.ref().child("thumbnails").child(id);

    UploadTask uploadTask = ref.putFile(
      await _getThumbNail(videoPath),
    );
    TaskSnapshot snap = await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
  }

}