import 'package:flutter/material.dart';

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
