import 'dart:math';

import 'package:flutter/material.dart';

import 'global_utils.dart';

extension ScreenConfig on double {
  double get h => (MediaQuery.of(ctx).size.height) * this;
  double get w => MediaQuery.of(ctx).size.width * this;
  double get f {
    final width = MediaQuery.of(ctx).size.width;
    double val = (width / 1400) * this;
    return max(1, min(val, this));
  }
}
