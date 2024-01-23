import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;

class ViewPdf extends StatefulWidget {
  final String? path, judul;
  final bool? isPinjam;

  const ViewPdf({Key? key, this.path, this.judul, this.isPinjam = false})
      : super(key: key);

  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  PdfViewerController? _pdfViewerController;

  Uint8List? file;

  @override
  void initState() {
    super.initState();
    splitPdf();
  }

  Future<void> splitPdf() async {
    final documentBytes = await http.readBytes(Uri.parse(widget.path!));
    final PdfDocument outputDocument = PdfDocument();
    PdfDocument document = PdfDocument(inputBytes: documentBytes);
    Uint8List? byteFile;

    if (!widget.isPinjam!) {
      for (int i = 0; i < 10; i++) {
        PdfTemplate p = document.pages[i].createTemplate();
        outputDocument.pageSettings.setMargins(0);
        outputDocument.pages
            .add()
            .graphics
            .drawPdfTemplate(p, const Offset(0, 0));
      }

      byteFile = Uint8List.fromList(await outputDocument.save());
    } else {
      byteFile = Uint8List.fromList(await document.save());
    }

    setState(() {
      file = byteFile;
    });
    document.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: file != null
            ? Semantics(
                label: widget.judul!,
                child: SfPdfViewer.memory(
                  file!, // Halaman pertama yang ingin ditampilka
                  controller: _pdfViewerController,
                  // pageLayoutMode: PdfPageLayoutMode.single,
                ))
            : null);
  }
}
