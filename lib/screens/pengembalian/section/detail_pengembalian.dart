import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard_app_tut/model/ModelQuery.dart';
import 'package:web_dashboard_app_tut/services/FirebaseServices.dart';
import 'package:web_dashboard_app_tut/utils/Time.dart';
import 'package:web_dashboard_app_tut/widget/button/button_elevated_widget.dart';
import 'package:web_dashboard_app_tut/widget/text/text_widget.dart';

class DetailPengembalian extends StatefulWidget {
  final String? id;
  final Future<void> Function() onGetData;
  const DetailPengembalian({super.key, this.id, required this.onGetData});

  @override
  State<DetailPengembalian> createState() => _DetailPengembalianState();
}

class _DetailPengembalianState extends State<DetailPengembalian> {
  final fs = FirebaseServices();
  final time = Time();

  final double fontSizeDataCell = 18;

  void oHapus(String id) {
    fs.delete("pengembalian", id);
    widget.onGetData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: fs.query("pengembalian", [ModelQuery(key: "email", value: widget.id)]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final snapDocs = snapshot.data?.docs;
              final size = snapshot.data!.size;

              return DataTable(
                  headingRowColor:
                      MaterialStateProperty.resolveWith((states) => Colors.blue.shade200),
                  columns: [
                    DataColumn(
                        label: TextWidget(
                      "No.",
                      fontSize: fontSizeDataCell,
                    )),
                    DataColumn(
                        label: TextWidget("Judul Buku",
                            fontSize: fontSizeDataCell, fontWeight: FontWeight.bold)),
                    DataColumn(
                        label: TextWidget("Sisa hari",
                            fontSize: fontSizeDataCell, fontWeight: FontWeight.bold)),
                    DataColumn(
                        label: TextWidget("Denda",
                            fontSize: fontSizeDataCell, fontWeight: FontWeight.bold)),
                    DataColumn(
                        label: TextWidget("Gambar",
                            fontSize: fontSizeDataCell, fontWeight: FontWeight.bold)),
                    // DataColumn(label: Text("")),
                  ],
                  rows: List<DataRow>.generate(size, (index) {
                    Map<String, dynamic> data = snapDocs![index].data();
                    String id = snapDocs[index].id;
                    final number = index + 1;

                    return DataRow(cells: [
                      DataCell(Text(number.toString())),
                      DataCell(TextWidget(
                        data['judul_buku']!,
                        fontSize: fontSizeDataCell,
                      )),
                      DataCell(TextWidget(data['sisa_hari']!,
                          color: Colors.black, fontSize: fontSizeDataCell)),
                      DataCell(TextWidget("${data['denda']!}", fontSize: fontSizeDataCell)),
                      DataCell(Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Image.network(
                          data["image"]!,
                          width: 50,
                          height: 100,
                        ),
                      )),
                      // DataCell(ButtonElevatedWidget(
                      //   "Hapus",
                      //   fontSize: fontSizeDataCell,
                      //   backgroundColor: Colors.red,
                      //   onPressed: () {
                      //     oHapus(id);
                      //   },
                      // )),
                    ]);
                  }));
            }

            return Expanded(child: Center(child: CircularProgressIndicator()));
          }),
    );
  }
}
