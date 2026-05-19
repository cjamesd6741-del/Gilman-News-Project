import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'dart:async';
import 'dart:math';
import "package:flutter/material.dart";
import 'package:The_Gilman_News/games/game_components/curling_components/curlingball.dart';
import 'package:The_Gilman_News/games/game_components/curling_components/vector_arrow.dart';
import 'package:The_Gilman_News/games/game_components/curling_components/deadball.dart';
import 'package:The_Gilman_News/games/game_components/curling_components/targets.dart';
import 'package:The_Gilman_News/games/game_components/curling_components/settings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:The_Gilman_News/services/cache.dart';

class Curling extends StatefulWidget {
  // TODO: Fix slight text bug in high score when reset but idc rn to do it
  const Curling({super.key});

  @override
  State<Curling> createState() => _CurlingState();
}

class _CurlingState extends State<Curling> {
  final CurlingGame game = CurlingGame();
  bool setting_bool = false; //controls whether the settings menu builds or not
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 215, 228, 211),
        title: Text(
          "Curling",
          style: GoogleFonts.play(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          GameWidget(
            game: game,
            overlayBuilderMap: {
              'settings': (context, CurlingGame game) =>
                  SettingPage(game: game),
            },
          ),
          Positioned(
            child: Row(
              children: [
                Text(
                  game.paused ? "Close Settings" : "",
                  style: GoogleFonts.lora(fontSize: 20, color: Colors.white),
                ),
                if (game.paused) SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (game.paused) {
                        game.closesetting();
                      } else {
                        game.openSettings();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 70, 70, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                  ),
                  icon: Icon(
                    game.paused ? Icons.exit_to_app : Icons.settings,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            right: 20,
            bottom: 10,
          ),
        ],
      ),
    );
  }
}

class CurlingGame extends FlameGame with TapCallbacks, DragCallbacks {
  // TODO: implement automatic saving of settings
  @override
  Color backgroundColor() => const Color.fromARGB(255, 1, 124, 181);
  Vector2 drag_startpos = Vector2.zero();
  Vector2 drag_endpos = Vector2.zero();
  bool launching = true;
  bool in_animation = false;
  bool arrowbool = false;
  bool playing = false;
  bool vectors = false;
  bool update_requested_after_round = false;
  int num_of_tries = 5; //5 is a default can change through settings
  int tries_remaining =
      0; // this measures actively number of tries left whereas other one sets the number of tries per game
  int score = 0;
  double launch_constant = .35;
  late TextComponent score_component;
  late TextComponent end_text;
  late TextComponent high_score_text;
  late TextComponent start_text;
  CacheManager highscorecache = CacheManager();
  late int highscore;
  double cf = .3;

  List<Deadball> deadballs = [];
  List<Target> targets = [];
  List<double> radiuses = [130, 85, 40];
  List<Paint> target_paints = [
    Paint()..color = const Color.fromARGB(255, 98, 150, 176),
    Paint()..color = const Color.fromARGB(255, 75, 84, 144),
    Paint()..color = const Color.fromARGB(255, 25, 18, 87),
  ];
  late CurlingBall mainball = CurlingBall(
    radius: 15,
    position: Vector2(size.x / 2, size.y / 1.3),
    draw_vector_paint: vectors,
    cf: cf,
    stop: onballstop,
  );
  late VectorArrow arrow = VectorArrow(
    offset: Vector2.zero(),
    position: Vector2(size.x / 2, size.y / 2),
  );
  @override
  void onDragStart(DragStartEvent event) {
    if (launching && !in_animation && !paused) {
      drag_startpos = event.canvasPosition;
      add(arrow);
      arrowbool = true;

      arrow.position = drag_startpos;
      print(drag_startpos);
    }
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (launching && !in_animation && !paused) {
      drag_endpos += event.canvasDelta;
      arrow.offset = drag_endpos;
      print(drag_endpos);
    }
    super.onDragUpdate(event);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!playing) {
      playing = true;
      start();
    }
    super.onTapDown(event);
  }

  void start() async {
    highscore = await highscorecache.get("curling_highscore") ?? 0;
    tries_remaining = num_of_tries;
    try {
      remove(score_component);
    } catch (e) {}
    try {
      remove(start_text);
    } catch (e) {}
    try {
      remove(end_text);
    } catch (e) {}
    try {
      remove(high_score_text);
    } catch (e) {}
    if (end_text.text != "Game Over, Tap to start again") {
      end_text = TextComponent(
        anchor: Anchor.center,
        text: "Game Over, Tap to start again",
        position: Vector2(size.x / 2, size.y / 2 + 100),
        textRenderer: TextPaint(
          style: GoogleFonts.lora(
            fontSize: 20,
            color: const Color.fromARGB(255, 198, 195, 195),
          ),
        ),
      );
    }
    mainball.position = Vector2(size.x / 2, size.y / 1.3);
    add(mainball);
    add(
      high_score_text = TextComponent(
        anchor: Anchor.centerLeft,
        text: "High Score : ${highscore.toString()}",
        position: Vector2(10, size.y / 1.1 + 25),
        textRenderer: TextPaint(
          style: GoogleFonts.lora(
            fontSize: 20,
            color: const Color.fromARGB(255, 198, 195, 195),
          ),
        ),
      ),
    );
    add(
      score_component = TextComponent(
        anchor: Anchor.centerLeft,
        text: "Score : ${score.toString()}",
        position: Vector2(10, size.y / 1.1),
        textRenderer: TextPaint(
          style: GoogleFonts.lora(
            fontSize: 20,
            color: const Color.fromARGB(255, 198, 195, 195),
          ),
        ),
      ),
    );

    if (targets.length == 0) {
      for (int i = 0; i < 3; i++) {
        Target newtarget = Target(
          points: (i * 3) + 1,
          pointadd: (i == 0) ? 1 : 3,
          position: Vector2(size.x / 2, size.y / 4),
          radius: radiuses[i],
          paint: target_paints[i],
        );
        targets.add(newtarget);
        add(newtarget);
      }
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (launching && !in_animation && arrowbool && !paused) {
      launch(drag_endpos);
      remove(arrow);
      arrowbool = false;
      launching = false;
    }
    drag_endpos = Vector2.zero();
    drag_startpos = Vector2.zero();

    super.onDragEnd(event);
  }

  void openSettings() {
    overlays.add('settings');
    paused = true;
    pauseEngine();
  }

  void closesetting() {
    overlays.remove('settings');
    paused = false;
    resumeEngine();
  }

  void collisioncheck() {
    for (int i = 0; i < deadballs.length; i++) {
      _resolveCollision(mainball, deadballs[i]);
    }
    for (int a = 0; a < deadballs.length; a++) {
      Deadball ball1 = deadballs[a];
      for (int i = a + 1; i < deadballs.length; i++) {
        Deadball ball2 = deadballs[i];
        _resolveCollision(ball1, ball2);
      }
    }
  }

  void _resolveCollision(dynamic b1, dynamic b2) {
    Vector2 n = b1.position - b2.position;
    double distance = n.length;
    double minDistance = b1.radius + b2.radius;

    if (distance >= minDistance) return;
    double overlap = minDistance - distance;
    Vector2 separation = n.normalized() * (overlap / 2);
    b1.position.add(separation);
    b2.position.sub(separation);
    n.normalize();
    Vector2 veldiff = b1.velocity - b2.velocity;
    double vDotN = veldiff.dot(n);
    if (vDotN > 0) return;
    double e = .7; //elasticity of impulse
    double j = -(1 + e) * vDotN;
    j /= (1 / b1.mass + 1 / b2.mass);
    Vector2 impulse = Vector2(n.x * j, n.y * j);
    b1.velocity += impulse / b1.mass;
    b2.velocity += -impulse / b2.mass;
  }

  @override
  void update(double dt) {
    super.update(dt);
    collisioncheck();
  }

  void launch(Vector2 offset) {
    mainball.velocity = -offset * launch_constant;
  }

  void onballstop(Vector2 death_position) async {
    launching = true;
    Deadball newdeadball = Deadball(
      position: Vector2.zero(),
      radius: 15,
      mass: 20,
      cf: cf,
      draw_vector_paint: vectors,
    );
    newdeadball.position = mainball.position;
    deadballs.add(newdeadball);
    remove(mainball);
    await Future.delayed(Duration(milliseconds: 50));
    add(newdeadball);
    in_animation = true;
    await Future.delayed(Duration(milliseconds: 300));
    mainball.position = Vector2(size.x / 2, size.y / 1.3);
    await Future.delayed(Duration(milliseconds: 100));
    calculate_points();
    if (tries_remaining > 1) {
      add(mainball);
      await Future.delayed(Duration(milliseconds: 300));
      in_animation = false;
      tries_remaining--;
    } else {
      in_animation = false;
      out_of_tries();
    }
  }

  void updatecf(double value) {
    cf = value;
    for (int i = 0; i < deadballs.length; i++) {
      deadballs[i].cf = cf;
    }
    try {
      mainball.cf = cf;
    } catch (e) {}
  }

  void updatetries(int value) {
    num_of_tries = value;
  }

  void resethighscore() {
    highscorecache.save("curling_highscore", 0);
    highscore = 0;
    high_score_text.text = "High Score : ${highscore.toString()}";
  }

  void update_vector_drawing() {
    vectors = !vectors;
    for (Deadball d in deadballs) {
      d.draw_vector_paint = vectors;
    }
    mainball.draw_vector_paint = vectors;
  }

  void out_of_tries() async {
    calculate_points();
    if (score > highscore) {
      highscorecache.save("curling_highscore", score);
      high_score_text.text = "New High Score : ${score.toString()}";
      end_text.text = "High Score!!! Click to Play Again!";
    }
    score_component.add(
      MoveEffect.to(
        Vector2((size.x - score_component.width * 2.5) / 2, size.y / 2),
        EffectController(duration: 2, curve: Curves.easeInCirc),
      ),
    );
    score_component.add(
      ScaleEffect.to(
        Vector2(2.5, 2.5),
        EffectController(duration: 2, curve: Curves.easeIn),
      ),
    );
    high_score_text.add(
      MoveEffect.to(
        Vector2((size.x - high_score_text.width * 1.5) / 2, size.y / 2 + 50),
        EffectController(duration: 2, curve: Curves.easeInCirc),
      ),
    );
    high_score_text.add(
      ScaleEffect.to(
        Vector2(1.5, 1.5),
        EffectController(duration: 2, curve: Curves.easeIn),
        onComplete: () {
          add(end_text);
        },
      ),
    );
    remove_all();
    playing = false;
    launching = true;
  }

  void remove_all() {
    for (int i = 0; i < deadballs.length; i++) {
      remove(deadballs[i]);
    }
    score = 0;
    deadballs = [];
  }

  void calculate_points() {
    score = 0;
    for (int i = 0; i < deadballs.length; i++) {
      final ball = deadballs[i];
      for (int a = 0; a < targets.length; a++) {
        final target = targets[a];
        double delta = (ball.position - target.position).length2;
        if (delta < pow((ball.radius + target.radius), 2)) {
          score += target.pointadd;
          score_component.text = "Score : ${score.toString()}";
        }
        ;
      }
    }
  }

  @override
  FutureOr<void> onLoad() {
    add(
      start_text = TextComponent(
        text: "Tap To Start",
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2),
        textRenderer: TextPaint(
          style: GoogleFonts.play(fontSize: 40, color: Colors.white),
        ),
      ),
    );
    end_text = TextComponent(
      anchor: Anchor.center,
      text: "Game Over, Tap to start again",
      position: Vector2(size.x / 2, size.y / 2 + 100),
      textRenderer: TextPaint(
        style: GoogleFonts.lora(
          fontSize: 20,
          color: const Color.fromARGB(255, 198, 195, 195),
        ),
      ),
    );
    score_component = TextComponent(
      anchor: Anchor.center,
      text: "Score : ${score.toString()}",
      position: Vector2(50, size.y / 1.1),
      textRenderer: TextPaint(
        style: GoogleFonts.lora(
          fontSize: 20,
          color: const Color.fromARGB(255, 198, 195, 195),
        ),
      ),
    );
    return super.onLoad();
  }
}
