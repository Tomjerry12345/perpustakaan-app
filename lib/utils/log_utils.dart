import 'package:flutter/material.dart';
import 'package:perpustakaan_mobile/utils/Utils.dart';

void log(tag, {v}) {
  if (tag != null && v != null) {
    debugPrint("[d] : $tag => $v");
    return;
  }

  if (tag != null) {
    debugPrint("[d] : $tag");
    return;
  }
}

void showToast(String text, Color color) {
  Utils.showSnackBar(text, color);
}
