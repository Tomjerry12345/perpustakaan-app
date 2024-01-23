import 'package:flutter/material.dart';

void logO(t, m) {
  // ignore: avoid_print
  print("[log] $t => $m");
}

Future<void> dialogShow({context, widget}) async {
  await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return widget;
      });
}

Future<void> dialogShowCustomContent(
    {context, Widget? title, Widget? content, List<Widget>? actions}) async {
  await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: actions,
        );
      });
}

void dialogClose(context) {
  Navigator.of(context).pop();
}
