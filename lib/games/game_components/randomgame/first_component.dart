import "dart:async";
import "dart:math";
import 'package:apitest_2/games/game_components/randomgame/rectangle.dart';
import "package:flame/components.dart";
import "package:flutter/material.dart";

class FirstComponent extends PositionComponent {
  @override
  FutureOr<void> onLoad() {
    position = Vector2(100, 200);
    size = Vector2(100, 100);
    anchor = Anchor.center;
    scale = Vector2(1, 1);
    angle = pi / 4;
    add(SecondRectangle(position: size / 2, size: Vector2.all(45)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle = angle + .05;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), Paint()..color = Colors.green);
  }
}
