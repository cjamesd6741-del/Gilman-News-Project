import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'dart:async';
import 'dart:math';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:apitest_2/games/curling/curling_game.dart';
import 'package:google_fonts/google_fonts.dart';

// this page creates the menu which appears in the curling game when the settings button is pressed
class SettingPage extends StatefulWidget {
  final CurlingGame game;
  const SettingPage({super.key, required this.game});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color.fromARGB(255, 17, 15, 71),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Settings",
                style: GoogleFonts.googleSans(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),

            Slider(
              value: widget.game.cf,
              onChanged: (value) {
                setState(() {
                  widget.game.updatecf(value);
                });
              },
              min: 0,
              max: 5,
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Coefficient of Friction : ${widget.game.cf.toStringAsFixed(2)}",
                style: GoogleFonts.libertinusMath(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
