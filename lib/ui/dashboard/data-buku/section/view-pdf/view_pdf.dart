import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdf extends StatelessWidget {
  final String? path, judul;

  const ViewPdf({Key? key, this.path, this.judul}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Semantics(
            label: judul!,
            child: SfPdfViewer.network(
              path!,
              // pageLayoutMode: PdfPageLayoutMode.single,
            )));
  }
}
