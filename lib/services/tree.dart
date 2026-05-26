import 'package:flutter/material.dart';

class HierarchyTree extends StatelessWidget {
  List staff;
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
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: stafflength,
        itemBuilder: (context, index) {
          final person = staff[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 160,
                  child: Text(
                    person['role'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(child: Text(person['name'])),
              ],
            ),
          );
        },
      );
    }
    return SizedBox(); //empty invisible box
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
