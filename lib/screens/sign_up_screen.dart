import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Utils/pickimage.dart';
import 'package:instagram_clone/Utils/showmessage.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/log_in_screen.dart';
import 'package:instagram_clone/widgets/input_box.dart';
import 'package:instagram_clone/widgets/picture_box.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  Uint8List? _profilePic;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _usernameController.dispose();
    bioController.dispose();
  }

  void selectImmage() async {
    Uint8List pic = await pickImge(ImageSource.gallery);
    setState(() {
      _profilePic = pic;
    });
  }

  void navigateToLogIn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LogInScreen(),
      ),
    );
  }

  void signUpUser() async {

    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      password: _passController.text,
      email: _emailController.text,
      username: _usernameController.text,
      //bio: bioController.text,
      file: _profilePic!,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != "Success") {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    } else {
      _passController.clear();
      _emailController.clear();
      _usernameController.clear();
      
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.19,
                    child: Container(
                      color: Colors.transparent, //Colors.amber,
                      child: const Center(
                        child: PictureBox(
                          picture: 'assets/Instagram_logo_name.jpg',
                          height: 0.6,
                          width: 0.55,
                          ispost: false,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.17,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _profilePic != null
                            ? CircleAvatar(
                                radius: (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) * 0.06,
                                backgroundImage: MemoryImage(_profilePic!),
                                backgroundColor: Colors.transparent,
                              )
                            : CircleAvatar(
                                radius: (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) * 0.06,
                                backgroundImage:
                                    const AssetImage('assets/default_pp.png'),
                                backgroundColor: Colors.transparent,
                              ),
                        Positioned(
                          child: IconButton(
                            onPressed: selectImmage,
                            color: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: const Icon(Icons.circle),
                            iconSize: (MediaQuery.of(context).size.width +
                                    MediaQuery.of(context).size.height) *
                                0.12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Container(
                      color: Colors.transparent, //Colors.green,
                      child: Center(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: InputBox(
                            height: 0.45,
                            width: 0.8,
                            fontSize: 0.04,
                            hintText: 'Enter your username',
                            type: TextInputType.text,
                            isPass: false,
                            controler: _usernameController,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Container(
                      color: Colors.transparent, //Colors.blue,
                      child: Center(
                        child: Align(
                          //alignment: Alignment.bottomCenter,
                          child: InputBox(
                            height: 0.45,
                            width: 0.8,
                            fontSize: 0.04,
                            hintText: 'Enter your email',
                            type: TextInputType.emailAddress,
                            controler: _emailController,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Container(
                      color: Colors.transparent, //Colors.green,
                      child: Center(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: InputBox(
                            height: 0.45,
                            width: 0.8,
                            fontSize: 0.04,
                            hintText: 'Enter your password',
                            type: TextInputType.text,
                            isPass: true,
                            controler: _passController,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Container(
                      color: Colors.transparent, //Colors.deepPurpleAccent,
                      child: Center(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: FractionallySizedBox(
                            heightFactor: 0.45,
                            widthFactor: 0.8,
                            child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(),
                              child: InkWell(
                                onTap: signUpUser,
                                child: Container(
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            (MediaQuery.of(context).size.height +
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width) *
                                                0.01),
                                      ),
                                    ),
                                    color: blueColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Sign up',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.09,
                    child: Container(
                      color: Colors.transparent, //Colors.blueAccent,
                      child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: _isLoading
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.height * 0.3,
                                  child: const LinearProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Container(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.11,
                    child: Container(
                      //color: Color.fromARGB(255, 217, 72, 40),
                      child: Center(
                        child: Align(
                          //alignment: Alignment.bottomCenter,
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?   ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize:
                                        MediaQuery.of(context).size.width * 0.037,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: navigateToLogIn,
                                  child: Text(
                                    "Log in",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.037,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
