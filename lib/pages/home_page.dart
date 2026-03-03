import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/services/appbartext.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  TextStyle appbartextStyle = const TextStyle(fontSize: 30, height: 1.5);
  Textconfigure textconfigure = Textconfigure();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 72;
    final double height = textconfigure.textHeight(
      width,
      "Welcome to the News!",
      appbartextStyle,
    );
    debugPrint("$width + $height");
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 175, 206),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerboxisscrolled) {
          return [
            SliverAppBar(
              toolbarHeight: height + 100,
              flexibleSpace: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 10, 30),
                  child: Text(
                    "Welcome to the News!",
                    softWrap: true,
                    maxLines: null,
                    style: GoogleFonts.lora(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 8, 53, 90),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Material(
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.hardEdge, // clips everything inside
                elevation: 4, // optional shadow
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/current_articles');
                  },
                  child: Ink(
                    height: 300,
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/images/gilmanschool2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Current Articles",
                        style: TextStyle(fontSize: 50, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Material(
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.hardEdge,
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/followed_articles');
                  },
                  child: Ink(
                    height: 300,
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/images/Followed_Authors.jpeg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Followed Authors",
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                          Text(
                            "Articles",
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
