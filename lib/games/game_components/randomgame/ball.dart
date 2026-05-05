import "dart:async";
import "dart:math";
import "dart:ui";
import 'package:apitest_2/games/game_components/randomgame/rectangle.dart';
import "package:flame/collisions.dart";
import "package:flame/components.dart";
import "package:flame/effects.dart";
import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class BallComponent extends CircleComponent with CollisionCallbacks {
  BallComponent({required this.number, required super.radius})
    : super(
        anchor: Anchor.center,
        children: [
          CircleHitbox(radius: radius, collisionType: CollisionType.passive),
        ],
      );
  final Paint paint = Paint()..color = Colors.brown;

  Vector2 velocity = Vector2.zero();
  final int number;
  late TextComponent numbertext;
  late Card testcard;

  @override
  FutureOr<void> onLoad() {
    numbertext = TextComponent(
      text: "$number",
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
    add(numbertext);
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2(0, 0), EffectController(duration: 5)),
        RemoveEffect(),
      ]),
    );
    return super.onLoad();
  }

  void hit() {
    print("hello");
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    position += velocity;
    if (velocity != 0) {
      velocity.y = velocity.y + (velocity.y * 2 * -dt);
      velocity.x = velocity.x + (velocity.x * 2 * -dt);
      if (velocity.x.abs() <= .05 && velocity.y.abs() <= .05) {
        velocity = Vector2.zero();
      }
    }
    ;
    super.update(dt);
  }
}
