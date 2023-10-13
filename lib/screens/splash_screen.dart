import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            VerticalDivider(),
            Image(
              height: 100,
              width: 100,
              image: AssetImage('assets/Instagram_logo_name.jpg'),
            ),
          ],
        ),
      ),
    );
  }
}
