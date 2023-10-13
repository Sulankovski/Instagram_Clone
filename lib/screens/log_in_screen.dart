import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Utils/showmessage.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/widgets/input_box.dart';
import 'package:instagram_clone/widgets/picture_box.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  void navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void logInUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().logInUser(
      email: _emailController.text,
      password: _passController.text,
    );

    if (res == "Success") {
      _emailController.clear();
      _passController.clear();

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.11,
                  child: Container(), /* Container(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),*/
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Container(
                          color: Colors.transparent, // Colors.amber,
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
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Container(
                          color: Colors.transparent, // Colors.blue,
                          child: Center(
                            child: Align(
                              alignment: Alignment.bottomCenter,
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
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Container(
                          color: Colors.transparent, // Colors.green,
                          child: Center(
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Container(
                          color: Colors.transparent, // Colors.deepPurpleAccent,
                          child: Center(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: FractionallySizedBox(
                                heightFactor: 0.45,
                                widthFactor: 0.8,
                                child: MediaQuery(
                                  data: MediaQuery.of(context).copyWith(),
                                  child: InkWell(
                                    onTap: logInUser,
                                    child: Container(
                                      decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  (MediaQuery.of(context)
                                                              .size
                                                              .height +
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width) *
                                                      0.01),
                                            ),
                                          ),
                                          color: blueColor),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Log In',
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
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.14,
                  child: Container(
                    color: Colors.transparent, // Colors.blueAccent,
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
                  height: MediaQuery.of(context).size.height * 0.105,
                  child: Container(
                    //color: Colors.amber,
                    child: Center(
                      child: Align(
                        //alignment: Alignment.bottomCenter,
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?  ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.037,
                                ),
                              ),
                              GestureDetector(
                                onTap: navigateToSignUp,
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.width * 0.037,
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
    );
  }
}
