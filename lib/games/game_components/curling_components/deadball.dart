import "dart:async";
import "dart:math";
import "dart:ui";
import 'package:apitest_2/games/game_components/randomgame/rectangle.dart';
import "package:apitest_2/services/tree.dart";
import "package:flame/collisions.dart";
import "package:flame/components.dart";
import "package:flame/effects.dart";
import "package:flutter/material.dart";

class Deadball extends CircleComponent {
  double mass;
  double cf;
  Deadball({
    required super.position,
    required super.radius,
    required this.mass,
    required this.cf,
  }) : super(anchor: Anchor.center);

  Vector2 velocity = Vector2.zero();
  Paint vector_paint = Paint()
    ..color = const Color.fromARGB(255, 25, 108, 54)
    ..strokeWidth = 3;

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position += velocity * dt;
    if (!velocity.isZero()) {
      velocity.y = velocity.y + (velocity.y * cf * -dt);
      velocity.x = velocity.x + (velocity.x * cf * -dt);
      if (velocity.x.abs() <= 2 && velocity.y.abs() <= 2) {
        velocity = Vector2.zero();
      }
    }
    ;
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.save();
    canvas.translate(radius, radius);
    canvas.drawLine(Offset(0, 0), Offset(velocity.x, velocity.y), vector_paint);
    canvas.drawLine(Offset(0, 0), Offset(velocity.x, 0), vector_paint);
    canvas.drawLine(
      Offset(velocity.x, 0),
      Offset(velocity.x, velocity.y),
      vector_paint,
    );
    canvas.restore();
  }
}
