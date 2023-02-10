import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TextBoxNumber extends StatelessWidget {
  TextEditingController controller;
  String label;
  TextBoxNumber({Key? key, required this.controller, required this.label})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
        } else if (value.contains(RegExp(r'[a-z]')) ||
            value.contains(RegExp(r'[A-Z]'))) {
          return 'Please Input Only Number !';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
