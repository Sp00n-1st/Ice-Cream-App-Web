import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TextBoxInput extends StatelessWidget {
  TextEditingController controller;
  String label;
  int maxLines;
  TextBoxInput(
      {Key? key,
      required this.controller,
      required this.label,
      this.maxLines = 1})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
          border: const OutlineInputBorder(),
          labelText: label,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w700, color: Colors.black87)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Can\'t Be Empty !';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
