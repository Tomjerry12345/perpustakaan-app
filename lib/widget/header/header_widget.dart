import 'package:flutter/material.dart';
import 'package:admin_perpustakaan/utils/position.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final Function()? onBackPressed;
  const HeaderWidget({super.key, this.title = "", this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onBackPressed != null)
                IconButton(
                    onPressed: onBackPressed,
                    icon: const Icon(Icons.arrow_back)),
              H(24),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        V(48),
      ],
    );
  }
}
