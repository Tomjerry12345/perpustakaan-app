import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_perpustakaan/model/ModelQuery.dart';
import 'package:admin_perpustakaan/services/FirebaseServices.dart';
import 'package:admin_perpustakaan/utils/Time.dart';
import 'package:admin_perpustakaan/widget/button/button_elevated_widget.dart';
import 'package:admin_perpustakaan/widget/text/text_widget.dart';

class DetailPeminjaman extends StatefulWidget {
  final String? id;
  const DetailPeminjaman({super.key, this.id});

  @override
  State<DetailPeminjaman> createState() => _DetailPeminjamanState();
}

class _DetailPeminjamanState extends State<DetailPeminjaman> {
  final fs = FirebaseServices();
  final time = Time();

  final double fontSizeDataCell = 10;

  Future<void> onKonfirmasi(String id) async {
    var getDate = time.getDateByRange(14);

    final tanggalPengembalian = "${time.getYear()}-${getDate[1]}-${getDate[0]}";
    await fs.update("peminjaman", id, {
      "konfirmasi": true,
      "denda": 0,
      "tanggal_peminjaman": time.getTimeNow(),
      "tanggal_pengembalian": tanggalPengembalian,
    });
  }

  void onPengembalian(Map<String, dynamic> data) {
    print(data);
    fs.add("pengembalian", {
      "email": data["email"],
      "nama_peminjam": data["nama_peminjam"],
      "judul_buku": data["judul_buku"],
      "pengarang": data["pengarang"],
      "tanggal_peminjaman": data["tanggal_peminjaman"],
      "tanggal_pengembalian": data["tanggal_pengembalian"],
      "denda": data["denda"],
      "sisa_hari": !data["isTenggat"]
          ? "${data['sisa_hari']} Hari"
          : "Lewat ${data['sisa_hari']} Hari",
      "image": data["image"],
    });
    oHapus(data["id"]);
  }

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
          stream: fs.query(
              "peminjaman", [ModelQuery(key: "email", value: widget.id)]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final snapDocs = snapshot.data?.docs;
              final size = snapshot.data!.size;

              return DataTable(
                  headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue.shade200),
                  columns: [
                    DataColumn(
                        label: TextWidget(
                      "No.",
                      fontSize: fontSizeDataCell,
                    )),
                    DataColumn(
                        label: TextWidget("Judul Buku",
                            fontSize: fontSizeDataCell,
                            fontWeight: FontWeight.bold)),
                    DataColumn(
                        label: TextWidget("Pengarang",
                            fontSize: fontSizeDataCell,
                            fontWeight: FontWeight.bold)),
                    DataColumn(
                        label: TextWidget("Rak Buku",
                            fontSize: fontSizeDataCell,
                            fontWeight: FontWeight.bold)),
                    DataColumn(
                        label: TextWidget("Sisa hari",
                            fontSize: fontSizeDataCell,
                            fontWeight: FontWeight.bold)),
                    DataColumn(
                        label: TextWidget("Denda",
                            fontSize: fontSizeDataCell,
                            fontWeight: FontWeight.bold)),
                    DataColumn(
                        label: TextWidget("Gambar",
                            fontSize: fontSizeDataCell,
                            fontWeight: FontWeight.bold)),
                    DataColumn(label: Text("")),
                    DataColumn(label: Text("")),
                    // DataColumn(label: Text("")),
                  ],
                  rows: List<DataRow>.generate(size, (index) {
                    Map<String, dynamic> data = snapDocs![index].data();
                    String id = snapDocs[index].id;
                    final number = index + 1;
                    int sisaHariNow = 0;
                    int denda = 0;
                    bool isTenggat = false;

                    if (data['tanggal_pengembalian'] != null) {
                      final tanggalPeminjaman =
                          data['tanggal_pengembalian'].toString().split("-");
                      final datePeminjaman = int.parse(tanggalPeminjaman[2]);
                      final monthPeminjaman = int.parse(tanggalPeminjaman[1]);
                      final yearPeminjaman = int.parse(tanggalPeminjaman[0]);

                      sisaHariNow = time.getJumlahHariDate(
                          yearPeminjaman, monthPeminjaman, datePeminjaman);

                      if (sisaHariNow == 0) {
                        sisaHariNow = 1;
                        isTenggat = true;
                        denda = sisaHariNow * 1000;
                      } else if (sisaHariNow < 0) {
                        sisaHariNow = sisaHariNow.abs();
                        isTenggat = true;
                        denda = sisaHariNow * 1000;
                      }

                      data.addAll({
                        "denda": denda,
                        "sisa_hari": sisaHariNow,
                        "id": id,
                        "isTenggat": isTenggat
                      });
                    }

                    return DataRow(cells: [
                      DataCell(Text(number.toString())),
                      DataCell(TextWidget(
                        data['judul_buku']!,
                        fontSize: fontSizeDataCell,
                      )),
                      DataCell(TextWidget(data['pengarang']!,
                          fontSize: fontSizeDataCell)),
                      DataCell(
                          TextWidget(data['rak']!, fontSize: fontSizeDataCell)),
                      DataCell(TextWidget(
                          !isTenggat
                              ? "$sisaHariNow"
                              : "Lewat $sisaHariNow Hari",
                          color: !isTenggat ? Colors.black : Colors.red,
                          fontSize: fontSizeDataCell)),
                      DataCell(TextWidget(denda > 0 ? "$denda" : "-",
                          fontSize: fontSizeDataCell)),
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
                              fontSize: fontSizeDataCell,
                              onPressed: () {
                                onPengembalian(data);
                              },
                            )
                          : ButtonElevatedWidget(
                              "Konfirmasi",
                              backgroundColor: Colors.green,
                              fontSize: fontSizeDataCell,
                              onPressed: () {
                                onKonfirmasi(id);
                              },
                            )),
                      DataCell(ButtonElevatedWidget(
                        "Perpanjangan",
                        backgroundColor: Colors.blue,
                        fontSize: fontSizeDataCell,
                        onPressed: data["konfirmasi"]! && sisaHariNow < 7
                            ? () {
                                onPerpanjangan(id);
                              }
                            : null,
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
