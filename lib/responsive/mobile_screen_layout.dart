import 'package:instagram_clone/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Utils/global_variables.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/splash_screen.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  void navigationBarTapped(int page) {
    setState(() {
    pageController.jumpToPage(page);
    });
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return user == null
        ? const SplashScreen()
        : Scaffold(
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChange,
              physics: const NeverScrollableScrollPhysics(),
              children: homeScreenItems,
            ),
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: mobileBackgroundColor,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: _page == 0 ? blueColor : secondaryColor,
                  ),
                  label: '',
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: _page == 1 ? blueColor : secondaryColor,
                  ),
                  label: '',
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_circle,
                    color: _page == 2 ? blueColor : secondaryColor,
                  ),
                  label: '',
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.movie_creation_outlined,
                    color: _page == 3 ? blueColor : secondaryColor,
                  ),
                  label: '',
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: _page != 4
                      ? CircleAvatar(
                          radius: 13,
                          backgroundImage: NetworkImage(
                            user.photoURL,
                          ),
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: blueColor,
                              ),
                            ),
                            CircleAvatar(
                              radius: 13,
                              backgroundImage: NetworkImage(
                                user.photoURL,
                              ),
                            ),
                          ],
                        ),
                  label: '',
                  backgroundColor: primaryColor,
                ),
              ],
              onTap: navigationBarTapped,
            ),
          );
  }
}
