import 'dart:async';
import 'dart:math';
import 'package:The_Gilman_News/games/game_components/randomgame/ball.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:The_Gilman_News/games/game_components/randomgame/rectangle.dart';
import 'package:flame/experimental.dart';

class RandomGameWidget extends StatefulWidget {
  const RandomGameWidget({super.key});

  @override
  State<RandomGameWidget> createState() => _RandomGameWidgetState();
}

class _RandomGameWidgetState extends State<RandomGameWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: []),
      body: GameWidget(game: RandomGame()),
    );
  }
}

class RandomGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => Colors.blue;
  @override
  bool get debugMode => false;
  late SecondRectangle secondR = SecondRectangle(
    size: Vector2(50, 130),
    position: Vector2(size.x / 2, size.y * 3 / 4),
  );
  final Random random = Random();
  late BallComponent ball = BallComponent(number: 10, radius: 20);
  late SpawnComponent ballspawner = SpawnComponent(
    period: 1,
    autoStart: false,
    area: Rectangle.fromLTRB(20, 20, size.x - 20, size.y - 20),
    factory: (amount) {
      return BallComponent(number: random.nextInt(10), radius: 20);
    },
  );

  int score = 0;
  late TextComponent scorecomponent;
  late Timer timer;
  int remainingtime = 10;
  late TextComponent timertext;
  bool isgamerunning = false;
  late TextComponent screenstart;

  @override
  void update(double dt) {
    scorecomponent.text = "$score";
    timer.update(dt);
    timertext.text = "Time Remaining : ${remainingtime.toString()}";
    super.update(dt);
  }

  void startgame() {
    add(secondR);
    isgamerunning = true;
    ballspawner.timer.start();
    timer.start();
    screenstart.text = "";
  }

  void updatescore(int add) {
    score += add;
  }

  @override
  Future<void> onLoad() async {
    add(ballspawner);
    add(
      scorecomponent = TextComponent(
        text: score.toString(),
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y - 20),
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 20, color: Colors.greenAccent),
        ),
      ),
    );
    add(
      timertext = TextComponent(
        text: "Time Remaining : ${remainingtime.toString()}",
        anchor: Anchor.center,
        position: Vector2(size.x / 2, 70),
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 20, color: Colors.greenAccent),
        ),
      ),
    );
    add(
      screenstart = TextComponent(
        text: "Tap to Begin",
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2),
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 50,
            color: const Color.fromARGB(255, 32, 38, 95),
          ),
        ),
      ),
    );
    timer = Timer(
      1,
      autoStart: false,
      repeat: true,
      onTick: () {
        remainingtime -= 1;
        if (remainingtime == 0) {
          finishgame();
        }
      },
    );

    return super.onLoad();
  }

  void finishgame() {
    secondR.position = size / 2;
    remove(secondR);
    timer.stop();
    screenstart.text = "Tap to Begin";
    isgamerunning = false;
    score = 0;
    remainingtime = 10;
    ballspawner.timer.stop();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
