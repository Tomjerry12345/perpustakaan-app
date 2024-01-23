import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPdfSplitArgs {
  /// File path of the pdf to split
  final String filePath;

  /// Target directory to put files
  final String outDirectory;

  /// Prefix for each pdf page file, default value is 'page_'
  final String outFilePrefix;

  FlutterPdfSplitArgs(this.filePath, this.outDirectory,
      {this.outFilePrefix = "page_"});

  Map get toMap => {
        "filePath": filePath,
        "outDirectory": outDirectory,
        "outFileNamePrefix": outFilePrefix,
      };
}

class FlutterPdfSplitResult {
  int? pageCount;
  late List<String> pagePaths;

  FlutterPdfSplitResult(Map result)
      : assert(result.containsKey("pageCount") &&
            result.containsKey("pagePaths") &&
            result["pagePaths"] is List) {
    pageCount = result["pageCount"];
    pagePaths = <String>[];
    for (var path in (result["pagePaths"] as List)) {
      if (path is String) pagePaths.add(path);
    }
  }
}

class FlutterPdfSplit {
  static const MethodChannel _channel = MethodChannel('flutter_pdf_split');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<FlutterPdfSplitResult> split(FlutterPdfSplitArgs args) async {
    return _split(args);
  }

  /// Splits PDF file [value] and returns the page count.
  static Future<FlutterPdfSplitResult> _split(FlutterPdfSplitArgs args) async {
    Map<dynamic, dynamic> result =
        await (_channel.invokeMethod('split', args.toMap));
    return FlutterPdfSplitResult(result);
  }
}
