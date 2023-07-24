import 'package:flutter/material.dart';

void logO(t, m) {
  print("[log] $t => $m");
}

Future<void> dialogShow({context, widget}) async {
  await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return widget;
      });
}

void dialogClose(context) {
  Navigator.of(context).pop();
}
