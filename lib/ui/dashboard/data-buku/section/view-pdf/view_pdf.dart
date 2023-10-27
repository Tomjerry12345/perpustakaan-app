import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdf extends StatefulWidget {
  final String? path, judul;

  const ViewPdf({Key? key, this.path, this.judul}) : super(key: key);

  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  PdfViewerController? _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _pdfViewerController?.addListener(() {
      print(_pdfViewerController?.pageNumber);
      if (_pdfViewerController?.pageNumber == 5) {
        _pdfViewerController?.removeListener(() { });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Semantics(
            label: widget.judul!,
            child: SfPdfViewer.network(
              widget.path!, // Halaman pertama yang ingin ditampilka
              controller: _pdfViewerController,
              // pageLayoutMode: PdfPageLayoutMode.single,
            )));
  }
}
