import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BukuTamu extends StatefulWidget {
  const BukuTamu({Key? key}) : super(key: key);

  @override
  State<BukuTamu> createState() => _BukuTamuState();
}

class _BukuTamuState extends State<BukuTamu> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection("tamu").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 30, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Buku Tamu",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.black54,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 40, top: 15),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                headingRowColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Colors.blue.shade200),
                                columns: [
                                  DataColumn(label: Text("No anggota")),
                                  DataColumn(label: Text("Nama")),
                                  DataColumn(label: Text("Alamat")),
                                  DataColumn(label: Text("Tanggal berkunjung")),
                                  DataColumn(label: Text("Pekerjaan")),
                                  DataColumn(label: Text("No Hp")),
                                ],
                                rows: List<DataRow>.generate(
                                    snapshot.data!.docs.length, (index) {
                                  DocumentSnapshot data =
                                      snapshot.data!.docs[index];

                                  return DataRow(cells: [
                                    DataCell(Text(data['no_anggota'])),
                                    DataCell(Text(data['nama'])),
                                    DataCell(Text(data['alamat'])),
                                    DataCell(Text(data['tanggal'])),
                                    DataCell(Text(data['pekerjaan'])),
                                    DataCell(Text(data['noHp'])),
                                  ]);
                                })),
                          ),
                          //Now let's set the pagination
                          SizedBox(
                            height: 40.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Expanded(
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}