import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextboxDisplay extends StatelessWidget {
  double size;
  String label;

  TextboxDisplay({Key? key, required this.label, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.orange, border: Border.all(color: Colors.black)),
      child: MaterialButton(
          onPressed: () {},
          child: Center(
              child: Text(
            label,
            style: GoogleFonts.poppins(),
          ))),
      width: size,
      height: 60,
    );
  }
}
