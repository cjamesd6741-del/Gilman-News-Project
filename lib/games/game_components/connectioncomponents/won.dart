import "package:flame/effects.dart";
import "package:flutter/material.dart";

class WinBanner extends StatefulWidget {
  // misnomer, this handles winning and losing banner
  VoidCallback leave;
  bool outcome;
  VoidCallback removebanner;
  double width;
  double height;
  WinBanner({
    super.key,
    required this.leave,
    required this.removebanner,
    required this.height,
    required this.width,
    required this.outcome,
  });

  @override
  State<WinBanner> createState() => _WinBannerState();
}

class _WinBannerState extends State<WinBanner> {
  bool opacity = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        opacity = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      opacity: opacity ? 1 : 0,
      child: Container(
        width: widget.width,
        height: widget.height,
        child: AlertDialog(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
          content: Text(
            widget.outcome ? "YOU LOST" : "YOU WON!",
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            IconButton(
              onPressed: () {
                widget.leave();
              },
              icon: Icon(Icons.arrow_back),
              alignment: Alignment.bottomLeft,
            ),
            IconButton(
              onPressed: () {
                widget.removebanner();
              },
              icon: Icon(Icons.close),
              alignment: Alignment.bottomLeft,
            ),
          ],
        ),
      ),
    );
  }
}
