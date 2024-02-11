import 'package:flutter/material.dart';

class TextfieldComponent extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final Color color;
  final TextInputType inputType;
  final String label;
  final Color colorText;

  const TextfieldComponent(
      {super.key,
      this.hintText = "",
      this.onChanged,
      this.controller,
      this.color = Colors.white70,
      this.inputType = TextInputType.text,
      this.label = "",
      this.colorText = Colors.black});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: inputType,
      controller: controller,
      onChanged: onChanged,
      cursorColor: Colors.black,
      decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 1.0,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              // color: HexColor("#019267"),
              color: Colors.blue,
              width: 1.0,
            ),
          ),
          filled: true,
          hintStyle: const TextStyle(color: Color(0xff2BB1EB)),
          hintText: hintText,
          label: Text(
            label,
            style: TextStyle(color: colorText),
          ),
          fillColor: color),
    );
  }
}
