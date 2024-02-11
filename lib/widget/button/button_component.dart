import 'package:flutter/material.dart';

class ButtonElevatedComponent extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final Color bg;
  final Color fg;
  final double? w;
  final double? h;
  final Color? cb;
  final double radius;
  const ButtonElevatedComponent(this.title,
      {super.key,
      required this.onPressed,
      this.bg = Colors.black,
      this.fg = Colors.white,
      this.w,
      this.h,
      this.cb,
      this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      height: h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          padding: const EdgeInsets.all(16),
          minimumSize: const Size(120, 40),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              side: BorderSide(color: cb ?? bg, width: 1)),
        ),
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
