import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Utils/pickimage.dart';
import 'package:instagram_clone/Utils/showmessage.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/confirm_screen.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  final TextEditingController _descriptionCOntroler = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLoaging = false;
  bool isPost = true;

  void postPicture(String uid, String username, String profImage) async {
    try {
      setState(() {
        _isLoaging = true;
      });
      String res = await AuthMethods().uploadPost(
        description: _descriptionCOntroler.text,
        file: _file!,
        uid: uid,
        username: username,
        profImage: profImage,
      );

      if (res == "Success") {
        // ignore: use_build_context_synchronously
        setState(() {
          clearImmage();
          _isLoaging = false;
        });
        showSnackBar("Posted!", context);
      } else {
        // ignore: use_build_context_synchronously
        setState(() {
          _isLoaging = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      // ignore: use_build_context_synchronously
      showSnackBar(err.toString(), context);
    }
  }

  _seletImage(BuildContext context) async {
    //BuildContext Parentcontext
    return showDialog(
      barrierDismissible: false,
      context:
          context, //Parentcontext  so ova se prezema kontekstot od tatkoto so sto ako se smeni megu skrinovi nema da se izgubi postot
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Center(
                child: Text(
                  'Create a post',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(
                  Icons.close,
                  size: 27,
                ),
              ),
            ],
          ),
          backgroundColor: mobileBackgroundColor,
          children: [
            SimpleDialogOption(
              child: const Center(
                child: Text(
                  'Take a photo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImge(
                  ImageSource.camera,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              child: const Center(
                child: Text(
                  'Choose from gallery',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImge(
                  ImageSource.gallery,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void clearImmage() {
    setState(() {
      _file = null;
    });
  }

  void onPageChange(int page) {
    setState(() {
      isPost == true ? isPost = false : isPost = true;
    });
  }

  pickVideo(ImageSource source, BuildContext context) async {
    final video = await ImagePicker().pickVideo(
      source: source,
    );
    if (video != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  showOptions(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: mobileBackgroundColor,
        children: [
          SimpleDialogOption(
            onPressed: () {
              pickVideo(ImageSource.gallery, context);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7),
                  child: Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              pickVideo(ImageSource.camera, context);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_outlined),
                Padding(
                  padding: EdgeInsets.all(7),
                  child: Text(
                    "Camera",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cancel_outlined),
                Padding(
                  padding: EdgeInsets.all(7),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionCOntroler.clear();
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: SizedBox(
                height: 50,
                child: PageView(
                  controller: PageController(
                    viewportFraction: 0.5,
                  ),
                  onPageChanged: onPageChange,
                  children: const [
                    Center(child: Text("Upload a post")),
                    Center(child: Text("Upload a real")),
                  ],
                ),
              ),
              centerTitle: true,
            ),
            body: isPost == true
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.upload,
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () => _seletImage(context), //so navigator
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: GestureDetector(
                      onTap: () {
                        showOptions(context);
                      },
                      child: Container(
                        width: 190,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            "Add video",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: clearImmage,
              ),
              actions: [
                TextButton(
                  onPressed: () => postPicture(
                    user!.uid,
                    user.username,
                    user.photoURL,
                  ),
                  style: const ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Text(
                    "Post  ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isLoaging == true
                    ? SizedBox(
                        width: MediaQuery.of(context).size.height * 0.3,
                        child: const LinearProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      //color: Colors.green,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.14,
                        height: MediaQuery.of(context).size.width * 0.14,
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.height / 5,
                          backgroundImage: NetworkImage(user!.photoURL),
                          //backgroundColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                    const VerticalDivider(),
                    Column(
                      children: [
                        Container(
                          //color: Colors.amber,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.1,
                            child: TextField(
                              controller: _descriptionCOntroler,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: "Write a caption!",
                                border: InputBorder.none,
                              ),
                              maxLines: 8,
                            ),
                          ),
                        ),
                        const Divider(),
                        Container(
                          //color: Colors.blue,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.35,
                            child: AspectRatio(
                              aspectRatio: 487 / 451,
                              child: Container(
                                decoration: BoxDecoration(
                                  //color: Colors.amber,
                                  image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.contain,
                                    alignment: FractionalOffset.topCenter,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
