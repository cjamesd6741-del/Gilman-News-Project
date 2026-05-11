import "dart:async";
import "package:flame/collisions.dart";
import "package:flame/components.dart";
import "package:flame/effects.dart";
import "package:flutter/material.dart";
import 'package:apitest_2/games/game_components/randomgame/randomgame.dart';
import 'package:apitest_2/games/game_components/randomgame/ball.dart';

class SecondRectangle extends RectangleComponent
    with CollisionCallbacks, HasGameReference<RandomGame> {
  SecondRectangle({required super.size, required super.position, super.angle})
    : super(anchor: Anchor.center);

  final Paint circlepainter = Paint()..color = Colors.greenAccent;
  Vector2 velocity = Vector2.zero();
  Vector2 target = Vector2.zero();
  Vector2 measuredvel = Vector2.zero();
  late Vector2 prevposition = position;
  final double speed = 100;
  @override
  FutureOr<void> onLoad() {
    paint = Paint()..color = const Color.fromARGB(255, 157, 126, 126);
    add(RectangleHitbox(collisionType: CollisionType.active));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    measuredvel = (position - prevposition) / dt;
    prevposition = position.clone();
    super.update(dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is BallComponent) {
      print("hit");
      game.updatescore(other.number);
      other.removeFromParent();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void move(Vector2 tappedpos) {
    target = tappedpos;
    Vector2 direction = tappedpos - position;
    velocity = direction.normalized();
    add(
      MoveEffect.by(
        tappedpos - position,
        EffectController(duration: 2, curve: Curves.easeInOut),
        onComplete: () {
          prevposition = position.clone();
        },
      ),
    );
  }

  void rotateSmoothly(Vector2 target) {
    add(
      RotateEffect.by(
        angleTo(target),
        EffectController(duration: .5, curve: Curves.easeInToLinear),
        onComplete: () {
          move(target);
        },
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset(size.x / 2, 0), size.x * .3, circlepainter);
  }
}
