import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class pengembalian extends StatefulWidget {
  const pengembalian({Key? key}) : super(key: key);

  @override
  State<pengembalian> createState() => _pengembalianState();
}

class _pengembalianState extends State<pengembalian> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Pengembalian",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
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
                          headingRowColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.blue.shade200),
                          columns: [
                            DataColumn(label: Text("ID")),
                            DataColumn(label: Text("Peminjam")),
                            DataColumn(label: Text("Judul Buku")),
                            DataColumn(label: Text("Nomor Buku")),
                            DataColumn(label: Text("Tanggal Peminjaman")),
                            DataColumn(label: Text("Tanggal Peminjaman")),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text("0")),
                              DataCell(Text("How to build a Flutter Web App")),
                              DataCell(Text("${DateTime.now()}")),
                              DataCell(Text("2.3K Views")),
                              DataCell(Text("102Comments")),
                              DataCell(Text("102Comments")),
                            ]),
                            DataRow(cells: [
                              DataCell(Text("1")),
                              DataCell(
                                  Text("How to build a Flutter Mobile App")),
                              DataCell(Text("${DateTime.now()}")),
                              DataCell(Text("21.3K Views")),
                              DataCell(Text("1020Comments")),
                              DataCell(Text("1020Comments")),
                            ]),
                            DataRow(cells: [
                              DataCell(Text("2")),
                              DataCell(Text("Flutter for your first project")),
                              DataCell(Text("${DateTime.now()}")),
                              DataCell(Text("2.3M Views")),
                              DataCell(Text("10K Comments")),
                              DataCell(Text("10K Comments")),
                            ]),
                          ]),
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
    );
  }
}
