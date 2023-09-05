import 'package:flutter/material.dart';

class ButtonElevatedWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color color;
  final String title;
  final Function()? onPressed;
  const ButtonElevatedWidget(this.title,
      {super.key, this.backgroundColor = Colors.black, this.onPressed, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(color: color),
      ),
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
    );
  }
}
