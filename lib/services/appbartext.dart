import 'package:flutter/material.dart';


class Textconfigure {
  double textHeight(
    double maxWidth,
    String text,
    TextStyle style,) 
    {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return tp.height;
  }

}