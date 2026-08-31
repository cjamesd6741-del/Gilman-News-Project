import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HierarchyTree extends StatelessWidget {
  final List staff;
  final int maxyear;
  final double screenwidth;
  HierarchyTree({
    super.key,
    required this.staff,
    required this.maxyear,
    required this.screenwidth,
  });

  @override
  Widget build(BuildContext context) {
    int stafflength = staff.length;
    if (stafflength != 0) {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: stafflength,
        itemBuilder: (context, index) {
          final person = staff[index];
          return Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 160,
                  child: Text(
                    person['role'],
                    style: GoogleFonts.lora(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 160,
                  child: Text(
                    person['name'],
                    style: GoogleFonts.lora(fontSize: 20),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    return Text(
      "No Masthead Given For This Year",
      style: GoogleFonts.lora(fontSize: 20),
    ); //empty invisible box
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..strokeWidth = 5;
    paint.color = Colors.red;
    canvas.drawLine(
      Offset(size.width / 5, size.height / 2),
      Offset(size.width * 4 / 5, size.height / 2),
      paint,
    );
  } // TODO : Family Tree

  @override
  bool shouldRepaint(covariant CustomPainter oldPainter) {
    return false;
  }
}
