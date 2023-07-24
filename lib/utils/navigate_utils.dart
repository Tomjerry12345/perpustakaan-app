import 'package:flutter/material.dart';

import 'global_utils.dart';

navigatePush(page) {
  Navigator.push(
    ctx,
    MaterialPageRoute(builder: (context) => page),
  );
}

navigatePop() {
  Navigator.pop(ctx);
}

navigatePushAndRemove(page) {
  Navigator.pushAndRemoveUntil(
      ctx, MaterialPageRoute(builder: (context) => page), (Route route) => false);
}
