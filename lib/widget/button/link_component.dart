import 'package:flutter/material.dart';
import 'package:perpustakaan_mobile/widget/text/text_widget.dart';

class LinkComponent extends StatelessWidget {
  final String title;
  final Color? color;
  final Function()? onTap;

  const LinkComponent(this.title, {super.key, this.color = Colors.blue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        child: TextWidget(
          title,
          fontSize: 16,
          color: color,
        ),
      ),
    );
  }
}
