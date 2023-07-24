import 'package:flutter/material.dart';

import '../main.dart';

class GlobalContext {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

BuildContext ctx = navigatorKey.currentContext!;
