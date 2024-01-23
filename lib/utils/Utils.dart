// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text, Color? color) {
    if (text == null) return;

    final snakBar =
        SnackBar(content: Text(text), backgroundColor: color ?? Colors.green);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snakBar);
  }
}
