import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdf extends StatelessWidget {
  final String? path;

  const ViewPdf({Key? key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: SfPdfViewer.network(
      'https://www.pearsonhighered.com/assets/samplechapter/0/3/2/1/0321537114.pdf',
      pageLayoutMode: PdfPageLayoutMode.single,
    )));
  }
}
