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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: MediaQuery.of(
          context,
        ).textScaler.clamp(minScaleFactor: .5, maxScaleFactor: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Card(
              color: const Color.fromARGB(255, 50, 45, 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Settings",
                      style: GoogleFonts.googleSans(
                        color: Colors.white,
                        fontSize: 35,
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
                    activeColor: const Color.fromARGB(255, 186, 188, 190),
                  ),
                  Center(
                    child: Text(
                      "Coefficient Of Friction : ${widget.game.cf.toStringAsFixed(2)}",
                      style: GoogleFonts.libertinusMath(
                        color: const Color.fromARGB(255, 220, 220, 220),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Slider(
                    value: widget.game.num_of_tries.toDouble(),
                    min: 1,
                    max: 15,
                    divisions: 15,
                    activeColor: const Color.fromARGB(255, 0, 75, 141),
                    onChanged: (value) {
                      setState(() {
                        widget.game.updatetries(value.toInt());
                      });
                    },
                  ),
                  Center(
                    child: Text(
                      "# Of Tries : ${widget.game.num_of_tries}",
                      style: GoogleFonts.libertinusMath(
                        color: const Color.fromARGB(255, 23, 123, 211),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Note* this only applies after end of current round",
                      style: GoogleFonts.libertinusMath(
                        color: const Color.fromARGB(255, 13, 104, 183),
                        fontSize: 15,
                      ),
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
                    activeColor: Color.fromARGB(255, 186, 188, 190),
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
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 75, 141),
                          ),
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
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 5,
                      vertical: 20,
                    ),
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
          ),
        ],
      ),
    );
  }
}
