import "dart:async";
import "package:flame/collisions.dart";
import "package:flame/components.dart";
import "package:flutter/material.dart";

class CurlingBall extends CircleComponent with CollisionCallbacks {
  double cf;
  Function stop;
  CurlingBall({
    required super.radius,
    required super.position,
    required this.cf,
    required this.stop,
  }) : super(
         anchor: Anchor.center,
         children: [
           CircleHitbox(radius: radius, collisionType: CollisionType.passive),
         ],
         paint: Paint()..color = Colors.red,
         priority: 2,
       );
  final Paint paint = Paint()..color = Colors.brown;
  Vector2 velocity = Vector2.zero();
  double mass = 50;
  late Card testcard;
  final Paint vectorpaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 5;

  @override
  FutureOr<void> onLoad() {
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
        stop(position);
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
    canvas.drawLine(Offset(0, 0), Offset(velocity.x, velocity.y), vectorpaint);
    canvas.drawLine(Offset(0, 0), Offset(velocity.x, 0), vectorpaint);
    canvas.drawLine(
      Offset(velocity.x, 0),
      Offset(velocity.x, velocity.y),
      vectorpaint,
    );
    canvas.restore();
  }
}
