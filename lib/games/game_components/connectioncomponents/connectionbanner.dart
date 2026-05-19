import "package:flutter/material.dart";

class ConnectionBanner extends StatefulWidget {
  String objects;
  String difficulty;
  String category;
  ConnectionBanner({
    super.key,
    required this.category,
    required this.objects,
    required this.difficulty,
  });

  @override
  State<ConnectionBanner> createState() => _ConnectionBannerState();
}

class _ConnectionBannerState extends State<ConnectionBanner> {
  Color getbannercolor(String diff) {
    switch (diff) {
      case "Easy":
        return const Color.fromARGB(255, 137, 192, 134);
      case "Medium":
        return const Color.fromARGB(255, 224, 219, 128);
      case "Hard":
        return const Color.fromARGB(255, 228, 167, 105);
      case "Very Hard":
        return const Color.fromARGB(255, 228, 52, 52);
      default:
        return Colors.grey;
    }
  }

  bool isvisible = false;

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isvisible = true;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isvisible ? 1 : 0,
      duration: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: getbannercolor(widget.difficulty),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      widget.objects,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      widget.category,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      widget.difficulty,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
