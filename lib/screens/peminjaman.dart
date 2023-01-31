import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:web_dashboard_app_tut/services/FirebaseServices.dart';

class peminjaman extends StatefulWidget {
  const peminjaman({Key? key}) : super(key: key);

  @override
  State<peminjaman> createState() => _peminjamanState();
}

class _peminjamanState extends State<peminjaman> {
  final firebaseServices = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firebaseServices.getAllStream("peminjaman"),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 40),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Peminjaman",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Colors.blue.shade200),
                                      columns: [
                                        DataColumn(label: Text("ID")),
                                        DataColumn(
                                            label: Text("Nama Peminjam")),
                                        DataColumn(label: Text("Judul Buku")),
                                        DataColumn(
                                            label: Text("Tanggal Peminjaman")),
                                        DataColumn(
                                            label:
                                                Text("Tanggal Pengembalian")),
                                      ],
                                      rows: snapshot.data!.docs
                                          .map((e) => DataRow(cells: [
                                                DataCell(Text("0")),
                                                DataCell(
                                                    Text(e["nama_peminjam"])),
                                                DataCell(Text(e["judul_buku"])),
                                                DataCell(Text(
                                                    e["tanggal_peminjaman"])),
                                                DataCell(Text(
                                                    e["tanggal_pengembalian"])),
                                              ]))
                                          .toList()),
                                  //Now let's set the pagination
                                  SizedBox(
                                    height: 40.0,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }
}
