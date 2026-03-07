import 'package:apitest_2/pages/routmanager.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Route_Manager()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "lib/images/Splash.png", // your wide image
          width: MediaQuery.of(context).size.width - 150,
          scale: 2,
        ),
      ),
    );
  }
}
