import "dart:async";
import "dart:math";
import "dart:ui";
import 'package:apitest_2/games/game_components/randomgame/rectangle.dart';
import "package:apitest_2/services/tree.dart";
import "package:flame/collisions.dart";
import "package:flame/components.dart";
import "package:flame/effects.dart";
import "package:flutter/material.dart";

class VectorArrow extends PositionComponent {
  Vector2 offset;
  VectorArrow({required super.position, required this.offset});
  @override
  final Paint painter = Paint()
    ..strokeWidth = 2
    ..color = Colors.red;
  double whisker = pi / 6;
  double length = 10;
  FutureOr<void> onLoad() {
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawLine(Offset.zero, offset.toOffset(), painter);
    double angle = atan2(offset.y, offset.x);
    Vector2 whisker1 = Vector2(
      length * cos(angle - whisker),
      length * sin(angle - whisker),
    );
    Vector2 whisker2 = Vector2(
      length * cos(angle + whisker),
      length * sin(angle + whisker),
    );
    canvas.drawLine(Offset.zero, whisker1.toOffset(), painter);
    canvas.drawLine(Offset.zero, whisker2.toOffset(), painter);
  }
}
