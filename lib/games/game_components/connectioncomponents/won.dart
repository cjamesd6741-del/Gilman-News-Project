import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class OutcomeBanner extends StatefulWidget {
  // TODO:Refactor into stateless, i have no idea why i made this stateful
  VoidCallback leave;
  bool outcome;
  VoidCallback removebanner;
  double width;
  double height;
  OutcomeBanner({
    super.key,
    required this.leave,
    required this.removebanner,
    required this.height,
    required this.width,
    required this.outcome,
  });

  @override
  State<OutcomeBanner> createState() => _OutcomeBannerState();
}

class _OutcomeBannerState extends State<OutcomeBanner> {
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
          backgroundColor: widget.outcome
              ? const Color.fromARGB(255, 190, 159, 159)
              : const Color.fromARGB(255, 157, 188, 161),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.outcome ? "YOU LOST" : "YOU WON!",
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  fontSize: 40,
                  color: widget.outcome
                      ? const Color.fromARGB(255, 70, 89, 200)
                      : Colors.white,
                ),
              ),
              if (widget.outcome)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Icon(
                      Icons.sentiment_very_dissatisfied,
                      size: 40,
                      color: const Color.fromARGB(255, 70, 89, 200),
                    ),
                    Icon(
                      Icons.sentiment_very_dissatisfied,
                      size: 40,
                      color: const Color.fromARGB(255, 70, 89, 200),
                    ),
                    Icon(
                      Icons.sentiment_very_dissatisfied,
                      size: 40,
                      color: const Color.fromARGB(255, 70, 89, 200),
                    ),
                  ],
                ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    widget.leave();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: widget.outcome
                        ? const Color.fromARGB(255, 70, 89, 200)
                        : Colors.white,
                    size: 30,
                  ),
                  alignment: Alignment.center,
                ),
                Text(
                  "Leave Game",
                  style: GoogleFonts.lora(
                    fontSize: 15,
                    color: widget.outcome
                        ? const Color.fromARGB(255, 70, 89, 200)
                        : Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    widget.removebanner();
                  },
                  icon: Icon(
                    Icons.close,
                    color: widget.outcome
                        ? const Color.fromARGB(255, 70, 89, 200)
                        : Colors.white,
                    size: 30,
                  ),
                  alignment: Alignment.center,
                ),
                Text(
                  "Close Popup",
                  style: GoogleFonts.lora(
                    fontSize: 15,
                    color: widget.outcome
                        ? const Color.fromARGB(255, 70, 89, 200)
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
