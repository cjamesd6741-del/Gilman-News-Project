import "package:flutter/material.dart";
import 'package:The_Gilman_News/services/globals.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ConnectionCard extends StatefulWidget {
  Function(String) add;
  Function(String) subtract;
  String text;
  double height;
  double width;
  bool isselected;
  bool cantbepressed;
  ConnectionCard({
    super.key,
    required this.add,
    required this.subtract,
    required this.text,
    required this.height,
    required this.width,
    required this.isselected,
    required this.cantbepressed,
  });

  @override
  State<ConnectionCard> createState() => _ConnectionCardState();
}

class _ConnectionCardState extends State<ConnectionCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        if (!widget.cantbepressed) {
          if (widget.isselected == true) {
            setState(() {
              widget.isselected = false;
              widget.subtract(widget.text);
            });
          } else if (Globals.numberofselected < 4) {
            setState(() {
              widget.isselected = true;
              widget.add(widget.text);
            });
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          height: widget.height,
          width: widget.width,
          alignment: Alignment.center,
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 203, 204, 203),
                offset: Offset(0, 5),
                blurRadius: 2,
              ),
            ],
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.isselected ? Colors.black : Colors.white,
              width: 1,
            ),
            color: widget.isselected
                ? const Color.fromARGB(19, 183, 180, 180)
                : const Color.fromARGB(255, 12, 66, 109),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: AutoSizeText(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.isselected ? Colors.black : Colors.white,
              ),
              maxLines: 2,
              wrapWords: false,
              minFontSize:
                  10, // It will wrap first, then shrink if it still doesn't fit
            ),
          ),
        ),
      ),
    );
  }
}
