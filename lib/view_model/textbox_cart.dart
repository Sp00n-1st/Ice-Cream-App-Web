import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextboxCart extends StatelessWidget {
  List<Widget> list = <Widget>[];
  double size;
  AlignmentGeometry alignment;
  TextboxCart(
      {Key? key,
      required this.list,
      required this.size,
      this.alignment = Alignment.centerLeft})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(right: BorderSide(width: 2, color: Colors.black))),
      child: Align(
          alignment: alignment,
          child: Column(
            children: list,
          )),
      width: size,
    );
  }
}
