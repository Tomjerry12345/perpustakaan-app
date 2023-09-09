import 'package:flutter/material.dart';

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
