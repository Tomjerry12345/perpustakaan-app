import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FormCustom extends StatefulWidget {
  final String text;
  final TextEditingController? controller;
  final TextInputType inputType;

  const FormCustom({
    Key? key,
    required this.text,
    this.inputType = TextInputType.text,
    this.controller,
  }) : super(key: key);

  @override
  State<FormCustom> createState() => _FormCustomState();
}

class _FormCustomState extends State<FormCustom> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.inputType,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.lock,
        //     // color: HexColor("#C3C6C3"),
        //     color: Colors.blue),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            // color: HexColor("#019267"),
            color: Colors.blue,
            width: 1.0,
          ),
        ),
        hintText: widget.text,
        hintStyle: TextStyle(color: Color(0xff2BB1EB)),
      ),
    );
  }
}
