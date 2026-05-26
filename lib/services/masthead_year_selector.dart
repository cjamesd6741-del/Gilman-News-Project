import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YearSelector extends StatefulWidget {
  double year;
  final double firstyear;
  final void Function(double value) changeyear;
  YearSelector({
    super.key,
    required this.year,
    required this.changeyear,
    required this.firstyear,
  });

  @override
  State<YearSelector> createState() => _YearSelectorState();
}

class _YearSelectorState extends State<YearSelector> {
  @override
  Widget build(BuildContext context) {
    double currentyear = widget.year;
    return Column(
      children: [
        SizedBox(height: 30),
        Center(
          child: Text(
            textAlign: TextAlign.center,
            "Viewing : ${currentyear.toInt().toString()}",
            style: GoogleFonts.lora(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 30),
        Center(
          child: Text(
            "Use Slider to Select Year",
            style: GoogleFonts.lora(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: const Color.fromARGB(255, 60, 78, 87),
            ),
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,

            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 18.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 35.0),
          ),
          child: Slider(
            value: currentyear,
            max: widget.firstyear,
            activeColor: Color.fromARGB(255, 0, 75, 141),
            inactiveColor: Color.fromARGB(255, 255, 255, 255),
            label: currentyear.toInt().toString(),
            min: 2004,
            divisions: widget.firstyear.toInt() - 2004,
            onChanged: (double value) {
              widget.changeyear(value);
              setState(() {
                currentyear = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
