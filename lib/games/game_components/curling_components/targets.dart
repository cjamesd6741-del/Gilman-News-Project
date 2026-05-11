import "dart:async";
import "package:flame/components.dart";
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class Target extends CircleComponent {
  int points;
  int pointadd;
  Target({
    required this.points,
    required super.position,
    required super.radius,
    required super.paint,
    required this.pointadd,
  }) : super(anchor: Anchor.center);

  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    add(
      TextComponent(
        text: points.toString(),
        anchor: Anchor.bottomCenter,
        position: Vector2(radius, 40),
        textRenderer: TextPaint(
          style: GoogleFonts.lora(
            fontSize: 20,
            color: const Color.fromARGB(255, 198, 195, 195),
          ),
        ),
      ),
    );
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      Paint()
        ..color = Colors.black
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    super.render(canvas);
  }
}
