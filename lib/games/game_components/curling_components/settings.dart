import "package:flutter/material.dart";
import 'package:The_Gilman_News/games/curling/curling_game.dart';
import 'package:google_fonts/google_fonts.dart';

// this page creates the menu which appears in the curling game when the settings button is pressed
class SettingPage extends StatefulWidget {
  final CurlingGame game;
  const SettingPage({super.key, required this.game});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Note if one were to refactor this code so set stae doesnt rebuild whole stats page, that would make this marginally more efficient but oh well
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color.fromARGB(255, 17, 15, 71),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            SizedBox(height: 15),
            Center(
              child: Text(
                "Settings",
                style: GoogleFonts.googleSans(
                  color: Colors.white,
                  fontSize: 35,
                ),
              ),
            ),
            SizedBox(height: 20),
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
            Center(
              child: Text(
                "Coefficient of Friction : ${widget.game.cf.toStringAsFixed(2)}",
                style: GoogleFonts.libertinusMath(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 20),
            Slider(
              value: widget.game.num_of_tries.toDouble(),
              min: 1,
              max: 15,
              divisions: 15,
              onChanged: (value) {
                setState(() {
                  widget.game.updatetries(value.toInt());
                });
              },
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "# of Tries : ${widget.game.num_of_tries}",
                    style: GoogleFonts.libertinusMath(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Note* this only applies after end of current round",
                    style: GoogleFonts.libertinusMath(
                      color: const Color.fromARGB(255, 181, 181, 181),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Slider(
              value: widget.game.launch_constant.toDouble(),
              min: .01,
              max: 5,
              onChanged: (value) {
                setState(() {
                  widget.game.launch_constant = value;
                });
              },
            ),
            Center(
              child: Text(
                "Launch Power : ${widget.game.launch_constant.toStringAsFixed(2)}",
                style: GoogleFonts.libertinusMath(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Material(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  splashColor: const Color.fromARGB(255, 43, 37, 77),
                  onTap: () {
                    widget.game.resethighscore();
                  },
                  child: Ink(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Reset High Score",
                        style: GoogleFonts.libertinusMath(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 5),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Transform.scale(
                      scale: 2,
                      child: Checkbox(
                        value: widget.game.vectors,
                        onChanged: (check) {
                          setState(() {
                            widget.game.update_vector_drawing();
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                    Text(
                      "Draw Vectors?",
                      style: GoogleFonts.libertinusMath(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    // SizedBox(width: 10), // finish in later update
                    // Transform.scale(
                    //   scale: 1.6,
                    //   child: Checkbox(
                    //     value: widget.game.machine_gun,
                    //     onChanged: (check) {
                    //       setState(() {
                    //         widget.game.machine_gun = !widget
                    //             .game
                    //             .machine_gun; // TODO: implement update machine_gun function
                    //       });
                    //     },
                    //     activeColor: Colors.green,
                    //   ),
                    // ),
                    // Text(
                    //   "Machine Gun Mode?",
                    //   style: GoogleFonts.libertinusMath(
                    //     color: Colors.white,
                    //     fontSize: 15,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
