import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class dataanggota extends StatefulWidget {
  const dataanggota({Key? key}) : super(key: key);

  @override
  State<dataanggota> createState() => _dataanggotaState();
}

class _dataanggotaState extends State<dataanggota> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Data Anggota",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 900, right: 20, top: 10, bottom: 10),
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
                child: TextField(
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  )),
            )),
          ),
          SizedBox(
            height: 10,
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
                            DataColumn(label: Text("Nama")),
                            DataColumn(label: Text("Alamat")),
                            DataColumn(label: Text("Pekerjaan")),
                            DataColumn(label: Text("Email")),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text("0")),
                              DataCell(Text("How to build a Flutter Web App")),
                              DataCell(Text("${DateTime.now()}")),
                              DataCell(Text("2.3K Views")),
                              DataCell(Text("102Comments")),
                            ]),
                            DataRow(cells: [
                              DataCell(Text("1")),
                              DataCell(
                                  Text("How to build a Flutter Mobile App")),
                              DataCell(Text("${DateTime.now()}")),
                              DataCell(Text("21.3K Views")),
                              DataCell(Text("1020Comments")),
                            ]),
                            DataRow(cells: [
                              DataCell(Text("2")),
                              DataCell(Text("Flutter for your first project")),
                              DataCell(Text("${DateTime.now()}")),
                              DataCell(Text("2.3M Views")),
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
