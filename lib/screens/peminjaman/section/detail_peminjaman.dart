import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard_app_tut/model/ModelQuery.dart';
import 'package:web_dashboard_app_tut/services/FirebaseServices.dart';
import 'package:web_dashboard_app_tut/utils/Time.dart';
import 'package:web_dashboard_app_tut/widget/button/button_elevated_widget.dart';
import 'package:web_dashboard_app_tut/widget/header/header_widget.dart';

class DetailPeminjaman extends StatefulWidget {
  final String? id;
  const DetailPeminjaman({super.key, this.id});

  @override
  State<DetailPeminjaman> createState() => _DetailPeminjamanState();
}

class _DetailPeminjamanState extends State<DetailPeminjaman> {
  final fs = FirebaseServices();
  final time = Time();

  Future<void> onKonfirmasi(String id) async {
    var getDate = time.getDateByRange(14);

    final tanggalPengembalian = "${time.getYear()}-${getDate[1]}-${getDate[0]}";
    await fs.update("peminjaman", id, {
      "konfirmasi": true,
      "tanggal_peminjaman": time.getTimeNow(),
      "tanggal_pengembalian": tanggalPengembalian,
    });
  }

  void onPengembalian() {}

  Future<void> onPerpanjangan(id) async {
    var getDate = time.getDateByRange(14);

    final tanggalPengembalian = "${time.getYear()}-${getDate[1]}-${getDate[0]}";

    await fs.update("peminjaman", id, {
      "tanggal_peminjaman": time.getTimeNow(),
      "tanggal_pengembalian": tanggalPengembalian,
    });
  }

  void oHapus(String id) {
    fs.delete("peminjaman", id);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: fs.query("peminjaman", [ModelQuery(key: "email", value: widget.id)]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final snapDocs = snapshot.data?.docs;
              final size = snapshot.data!.size;
              String title = "";

              if (size > 0) {
                title = snapDocs![0].data()["nama_peminjam"];
              }

              return Column(children: [
                HeaderWidget(
                  title: title,
                  onBackPressed: () async {
                    await fs.update("barcode", "code", {"code": "default"});
                  },
                ),
                DataTable(
                    headingRowColor:
                        MaterialStateProperty.resolveWith((states) => Colors.blue.shade200),
                    columns: const [
                      DataColumn(label: Text("No.")),
                      DataColumn(label: Text("Judul Buku")),
                      DataColumn(label: Text("Pengarang")),
                      DataColumn(label: Text("Rak Buku")),
                      DataColumn(label: Text("Sisa hari")),
                      DataColumn(label: Text("Gambar")),
                      DataColumn(label: Text("")),
                      DataColumn(label: Text("")),
                      DataColumn(label: Text("")),
                    ],
                    rows: List<DataRow>.generate(size, (index) {
                      Map<String, dynamic> data = snapDocs![index].data();
                      String id = snapDocs[index].id;
                      final number = index + 1;
                      int sisaHariNow = 0;

                      if (data['tanggal_pengembalian'] != null) {
                        final tanggalPeminjaman =
                            data['tanggal_pengembalian'].toString().split("-");
                        final datePeminjaman = int.parse(tanggalPeminjaman[2]);
                        final monthPeminjaman = int.parse(tanggalPeminjaman[1]);
                        final yearPeminjaman = int.parse(tanggalPeminjaman[0]);

                        sisaHariNow =
                            time.getJumlahHariDate(yearPeminjaman, monthPeminjaman, datePeminjaman);
                      }

                      return DataRow(cells: [
                        DataCell(Text(number.toString())),
                        DataCell(Text(data['judul_buku']!)),
                        DataCell(Text(data['pengarang']!)),
                        DataCell(Text(data['rak']!)),
                        DataCell(Text(sisaHariNow > 0 ? "$sisaHariNow" : "-")),
                        DataCell(Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Image.network(
                            data["image"]!,
                            width: 50,
                            height: 100,
                          ),
                        )),
                        DataCell(data["konfirmasi"]!
                            ? ButtonElevatedWidget(
                                "Pengembalian",
                                backgroundColor: Colors.cyan,
                                onPressed: () {
                                  onPengembalian();
                                },
                              )
                            : ButtonElevatedWidget(
                                "Konfirmasi",
                                backgroundColor: Colors.green,
                                onPressed: () {
                                  onKonfirmasi(id);
                                },
                              )),
                        DataCell(ButtonElevatedWidget(
                          "Perpanjangan",
                          backgroundColor: Colors.blue,
                          onPressed: data["konfirmasi"]! && sisaHariNow < 7
                              ? () {
                                  onPerpanjangan(id);
                                }
                              : null,
                        )),
                        DataCell(ButtonElevatedWidget(
                          "Hapus",
                          backgroundColor: Colors.red,
                          onPressed: () {
                            oHapus(id);
                          },
                        )),
                      ]);
                    }))
              ]);
            }

            return Expanded(child: Center(child: CircularProgressIndicator()));
          }),
    );
  }
}
