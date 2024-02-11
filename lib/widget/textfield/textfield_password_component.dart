import 'package:flutter/material.dart';

class TextfieldPasswordComponent extends StatefulWidget {
  final String hintText;
  final String label;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final Color colorText;
  final Color bg;

  const TextfieldPasswordComponent(
      {super.key,
      this.hintText = "",
      this.onChanged,
      this.controller,
      this.label = "",
      this.colorText = Colors.black,
      this.bg = Colors.white});

  @override
  State<TextfieldPasswordComponent> createState() =>
      _TextfieldPasswordComponentState();
}

class _TextfieldPasswordComponentState
    extends State<TextfieldPasswordComponent> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      controller: widget.controller,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
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
          hintText: widget.hintText,
          label: Text(
            widget.label,
            style: TextStyle(color: widget.colorText),
          ),
          fillColor: widget.bg),
    );
  }
}
