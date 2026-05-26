import 'package:The_Gilman_News/pages/routmanager.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:The_Gilman_News/services/cache.dart';
import 'package:uuid/uuid.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CacheManager cacheManager = CacheManager();
  final Uuid uuidmaker = Uuid();
  @override
  void initState() {
    super.initState();
    init_app();
  }

  void init_app() async {
    final minimumDisplayTime = Future.delayed(const Duration(seconds: 2));

    await minimumDisplayTime;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Route_Manager()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "lib/images/Splash.png", // your wide image
          width: MediaQuery.sizeOf(context).width - 150,
          scale: 2,
        ),
      ),
    );
  }
}
