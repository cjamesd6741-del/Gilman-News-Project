import 'dart:math';
import 'package:apitest_2/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:apitest_2/games/game_components/randomgame/randomgame.dart';
import 'package:apitest_2/games/game_components/connectioncomponents/cards.dart';
import 'package:collection/collection.dart';
import 'package:apitest_2/games/game_components/connectioncomponents/connectionbanner.dart';
import 'package:apitest_2/games/game_components/connectioncomponents/won.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Connections extends StatefulWidget {
  const Connections({super.key});

  @override
  State<Connections> createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  Globals global = Globals();
  List<String> selected = [];
  // Structure of input data is always [Diffculty, Category Name, Names]
  List<List> rawdata = [];

  Map<String, List<String>> nameddata = {}; // map to find difficulty from
  Map<String, List<String>> catdata = {}; // map to find category name from
  List<List<String>> unformatted = [];
  int guesses = 5; // num of guesses
  bool won = false; // triggers win screen
  bool lost = false; // triggers lose screen. triggered at end of lose animation
  bool pressed = false; // prevents spam clicking
  bool loseanimationbool = false; //prevents player from selecting cards
  Future<bool>? ready;

  List<String> objects = [];
  List<ConnectionCard> cards = [];
  late double cardwidth;
  late double cardheight;
  int numguessed = 0; // tracks num of selected cards
  List<List<String>> categoriesguessed = [];
  List<ConnectionBanner> bannersguessed = [];

  void loseanimation() async {
    lost = true;
    pressed = true;
    loseanimationbool = true;
    mapcards();
    await Future.delayed(Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() {
      selected = [];
      mapcards();
    });
    await Future.delayed(Duration(milliseconds: 1000));
    if (!mounted) return;
    List remaining = [];
    print(categoriesguessed);
    unformatted.forEach((e) {
      if (!categoriesguessed.any(
        (cat) => ListEquality().equals(e..sort(), cat..sort()),
      )) {
        remaining.add(e);
      }
    });
    for (int i = 0; i < remaining.length; i++) {
      if (!mounted) return;
      setState(() {
        selected = remaining[i];
        mapcards();
      });
      await Future.delayed(Duration(milliseconds: 500));
      if (!mounted) return;
      guesslogic();
      await Future.delayed(Duration(seconds: 2));
    }
  }

  void mapcards() {
    setState(() {
      cards = objects
          .map(
            (e) => ConnectionCard(
              key: ValueKey(e),
              add: add,
              subtract: removestring,
              text: e,
              height: cardheight,
              width: cardwidth,
              isselected: selected.contains(e),
              cantbepressed: loseanimationbool,
            ),
          )
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void organize_data() {
    rawdata.forEach((e) {
      String difficulty = e[0].toString();
      String categoryName = e[1].toString();
      List<String> words = List<String>.from(e[2]);
      nameddata[difficulty] = words;
      catdata[categoryName] = words;
    });
    unformatted = nameddata.values.toList();
    objects = [
      ...unformatted[0],
      ...unformatted[1],
      ...unformatted[2],
      ...unformatted[3],
    ];
    print(objects);
    objects.shuffle();
    cardheight = MediaQuery.of(context).size.height / 12;
    cardwidth = MediaQuery.of(context).size.width / 5;
    mapcards();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        rawdata = (args['connection_data'] as List).cast<List>();
        organize_data();
        setState(() {
          ready = Future.value(true);
        });
      }
    });
  }

  void add(String addition) {
    selected.add(addition);
    setState(() {
      Globals.numberofselected += 1;
      print(Globals.numberofselected);
    });

    print(selected.toString());
  }

  void removestring(String addition) {
    selected.remove(addition);
    setState(() {
      Globals.numberofselected--;
    });
    print(selected.toString());
  }

  void leave() {
    Globals.numberofselected = 0;
    Navigator.pop(context);
  }

  void guesslogic() async {
    if (unformatted.any(
          (e) => ListEquality().equals(e..sort(), selected..sort()),
        ) &&
        mounted) {
      setState(() {
        List<int> selectedpos = selected
            .map((e) => objects.indexOf(e))
            .toList();

        objects.removeWhere((word) => selected.contains(word));
        objects.insertAll(0, selected);
      });
      mapcards();

      await Future.delayed(Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() {
        numguessed++;
        objects.removeWhere((word) => selected.contains(word));
        categoriesguessed.add(selected);
        selected = [];
        Globals.numberofselected = 0;

        mapcards();

        bannersguessed = categoriesguessed
            .map(
              (e) => ConnectionBanner(
                key: Key(e.toString()),
                objects: e.join(", "),
                category: catdata.entries
                    .firstWhere(
                      (entry) =>
                          ListEquality().equals(entry.value..sort(), e..sort()),
                    )
                    .key,
                difficulty: nameddata.entries
                    .firstWhere(
                      (entry) =>
                          ListEquality().equals(entry.value..sort(), e..sort()),
                    )
                    .key,
              ),
            )
            .toList();
      });
      if (bannersguessed.length == 4) {
        print("hurray");
        setState(() {
          won = true;
        });
      } //second set state
    } // list equality check
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Globals.numberofselected = 0;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Welcome to Connections")),
        body: FutureBuilder(
          future: ready,
          builder: (context, asyncSnapshot) {
            if (!asyncSnapshot.hasError && asyncSnapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        double cwidth = (constraints.maxWidth - 24) / 4;
                        double cheight = (constraints.maxHeight - 24) / 6;
                        print(cheight);
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            ...cards.asMap().entries.map((e) {
                              return AnimatedPositioned(
                                key: e.value.key,
                                child: e.value,
                                duration: Duration(milliseconds: 200),
                                left: e.key % 4 * (cwidth + 8),
                                top:
                                    e.key ~/ 4 * cheight +
                                    (numguessed + 1) * cheight,
                              );
                            }).toList(),
                            ...bannersguessed
                                .asMap()
                                .entries
                                .map(
                                  (e) => AnimatedPositioned(
                                    key: e.value.key,
                                    top: 0 + (1 + e.key) * cheight,
                                    left: 0,
                                    width: constraints.maxWidth,
                                    height: cheight - 8,
                                    child: e.value,
                                    duration: Duration(milliseconds: 300),
                                  ),
                                )
                                .toList(),

                            if (won == true)
                              WinBanner(
                                leave: leave,
                                removebanner: () {
                                  setState(() {
                                    won = false;
                                  });
                                },
                                height: cheight * 4,
                                width: constraints.maxWidth,
                                outcome: lost,
                              ),
                            for (int i = 0; i < guesses; i++)
                              AnimatedPositioned(
                                top: cheight * 5,
                                width:
                                    constraints.maxWidth -
                                    ((guesses - 1 - i) * cwidth / 3) +
                                    i * cwidth / 3,
                                key: Key(i.toString()),
                                duration: Duration(milliseconds: 300),
                                child: Icon(
                                  key: Key(i.toString()),
                                  Icons.circle,
                                  size: cwidth / 4,
                                  color: const Color.fromARGB(255, 53, 53, 54),
                                ),
                              ),
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 300),
                              top: cheight * 5.5,
                              left: 0,
                              width: constraints.maxWidth,
                              key: Key("row"),
                              child: Row(
                                key: Key("row"),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      for (int i = 0; i < 1; i++) {
                                        if (!mounted) return;
                                        setState(() {
                                          objects.shuffle();
                                          mapcards();
                                        });
                                        await Future.delayed(
                                          Duration(milliseconds: 30),
                                        );
                                      }
                                    },
                                    child: Text("Shuffle"),
                                  ),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (selected.length == 4 && !pressed) {
                                        pressed = true;
                                        if (unformatted.any(
                                          (e) => ListEquality().equals(
                                            e..sort(),
                                            selected..sort(),
                                          ),
                                        )) {
                                          setState(() {
                                            List<int> selectedpos = selected
                                                .map((e) => objects.indexOf(e))
                                                .toList();

                                            objects.removeWhere(
                                              (word) => selected.contains(word),
                                            );
                                            objects.insertAll(0, selected);
                                          });
                                          mapcards();

                                          await Future.delayed(
                                            Duration(milliseconds: 500),
                                          );

                                          if (!mounted) return;
                                          setState(() {
                                            numguessed++;
                                            objects.removeWhere(
                                              (word) => selected.contains(word),
                                            );
                                            categoriesguessed.add(selected);
                                            selected = [];
                                            Globals.numberofselected = 0;

                                            mapcards();

                                            bannersguessed = categoriesguessed
                                                .map(
                                                  (e) => ConnectionBanner(
                                                    key: Key(e.toString()),
                                                    objects: e.join(", "),
                                                    category: catdata.entries
                                                        .firstWhere(
                                                          (entry) =>
                                                              ListEquality()
                                                                  .equals(
                                                                    entry.value
                                                                      ..sort(),
                                                                    e..sort(),
                                                                  ),
                                                        )
                                                        .key,
                                                    difficulty: nameddata
                                                        .entries
                                                        .firstWhere(
                                                          (entry) =>
                                                              ListEquality()
                                                                  .equals(
                                                                    entry.value
                                                                      ..sort(),
                                                                    e..sort(),
                                                                  ),
                                                        )
                                                        .key,
                                                  ),
                                                )
                                                .toList();
                                          });
                                          if (bannersguessed.length == 4) {
                                            print("hurray");
                                            setState(() {
                                              won = true;
                                            });
                                          } //second set state
                                        } // list equality check
                                        else {
                                          setState(() {
                                            guesses--;
                                          });
                                        }
                                        if (guesses == 0) {
                                          loseanimation();
                                        }
                                        pressed = false;
                                      } // if selected == 4
                                    },
                                    child: Text("Submit"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SpinKitFadingCircle(
                        color: Colors.blue,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
