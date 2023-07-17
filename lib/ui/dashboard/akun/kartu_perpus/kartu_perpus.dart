import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class KartuPerpus extends StatelessWidget {
  final pw.Document doc;

  const KartuPerpus({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        centerTitle: true,
        title: const Text("Preview"),
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "mydoc.pdf",
      ),
      //     Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Container(
      //     width: 500,
      //     height: 200,
      //     color: Colors.green,
      //     child: Column(children: [
      //       Container(
      //         height: 78,
      //         width: 500,
      //         color: Colors.amber,
      //         child: Column(
      //           children: [
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Container(
      //                   height: 50,
      //                   width: 50,
      //                   color: Colors.blue,
      //                 ),
      //                 SizedBox(
      //                   width: 8,
      //                 ),
      //                 Text(
      //                   "Kartu Perpustakaan",
      //                   style: TextStyle(
      //                       fontSize: 24, fontWeight: FontWeight.bold),
      //                 )
      //               ],
      //             ),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Text(
      //                   "SMP NEGERI 6 BULUKUMBA",
      //                   style: TextStyle(
      //                     fontSize: 12,
      //                   ),
      //                 )
      //               ],
      //             )
      //           ],
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Container(
      //               width: 70,
      //               height: 100,
      //               color: Colors.red,
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 children: [
      //                   Text("No.Anggota : 555"),
      //                   SizedBox(
      //                     height: 8,
      //                   ),
      //                   Text("Nama : Selvi Angrgreani"),
      //                   SizedBox(
      //                     height: 8,
      //                   ),
      //                   Text("Kelas : 2"),
      //                   SizedBox(
      //                     height: 8,
      //                   ),
      //                   Text("TTL : Bulukumba"),
      //                 ],
      //               ),
      //             )
      //           ],
      //         ),
      //       )
      //     ]),
      //   ),
      // )
    );
  }
}
