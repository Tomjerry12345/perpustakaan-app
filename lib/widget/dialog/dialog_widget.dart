import 'package:flutter/material.dart';

Future<void> dialogShow({context, widget}) async {
  await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: widget,
        );
      });
}

void dialogClose(context) {
  Navigator.of(context).pop();
}
