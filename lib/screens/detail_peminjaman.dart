import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard_app_tut/model/ModelQuery.dart';
import 'package:web_dashboard_app_tut/widget/header/header_widget.dart';

import '../services/FirebaseServices.dart';
import '../utils/log_utils.dart';

class DetailPeminjaman extends StatefulWidget {
  final String? id;
  const DetailPeminjaman({super.key, this.id});

  @override
  State<DetailPeminjaman> createState() => _DetailPeminjamanState();
}

class _DetailPeminjamanState extends State<DetailPeminjaman> {
  final fs = FirebaseServices();

  final dataDummy = [
    {
      "judul_buku": "One piece",
      "pengarang": "Echiro oda",
      "penerbit": "Toei animation",
      "kategori": "Adventure",
      "rak": "1",
      "sinopsis": "Blaaa blaaa",
      "halaman": "50",
      "image": "https://wallpapers.com/images/hd/anime-pictures-bj226rrdwe326upu.jpg",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        HeaderWidget(
          title: "Selvi angraeni",
          onBackPressed: () async {
            await fs.update("barcode", "code", {"code": "default"});
          },
        ),
        // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        //     stream: fs.query("peminjaman", [ModelQuery(key: "email", value: widget.id)]),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         log("snapshot", v: snapshot.data?.docs[0].data());
        //         return DataTable(
        //             headingRowColor:
        //                 MaterialStateProperty.resolveWith((states) => Colors.blue.shade200),
        //             columns: const [
        //               DataColumn(label: Text("No.")),
        //               DataColumn(label: Text("Judul Buku")),
        //               DataColumn(label: Text("Pengarang")),
        //               DataColumn(label: Text("Penerbit")),
        //               DataColumn(label: Text("Kategori")),
        //               DataColumn(label: Text("Rak Buku")),
        //               DataColumn(label: Text("Sinopsis")),
        //               DataColumn(label: Text("Halaman")),
        //               DataColumn(label: Text("Gambar")),
        //               // DataColumn(label: Text("Aksi")),
        //             ],
        //             rows: List<DataRow>.generate(dataDummy.length, (index) {
        //               Map<String, String> data = dataDummy[index];
        //               final number = index + 1;

        //               return DataRow(cells: [
        //                 DataCell(Text(number.toString())),
        //                 DataCell(Text(data['judul_buku']!)),
        //                 DataCell(Text(data['pengarang']!)),
        //                 DataCell(Text(data['penerbit']!)),
        //                 DataCell(Text(data['kategori']!)),
        //                 DataCell(Text(data['rak']!)),
        //                 DataCell(Container(
        //                   constraints: const BoxConstraints(
        //                     maxWidth: 50,
        //                   ),
        //                   child: Text(
        //                     data['sinopsis']!,
        //                   ),
        //                 )),
        //                 DataCell(Text(data['halaman']!)),
        //                 // DataCell(Text(data['halaman'])),
        //                 DataCell(Container(
        //                   child: Image.network(
        //                     data["image"]!,
        //                     width: 100,
        //                     height: 100,
        //                   ),
        //                 )),
        //               ]);
        //             }));
        //       }

        //       return Center(child: CircularProgressIndicator());
        //     }),
      ]),
    );
  }
}
