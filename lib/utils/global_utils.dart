import 'package:flutter/material.dart';

class GlobalContext {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

final navigatorKey = GlobalContext.navigatorKey;

BuildContext ctx = navigatorKey.currentContext!;
