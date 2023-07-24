import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String txt;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;

  const TextWidget(this.txt, {super.key, this.color, this.fontSize, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
