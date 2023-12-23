import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan_mobile/model/ModelQuery.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/utils/Time.dart';
import 'package:perpustakaan_mobile/utils/log_utils.dart';
import 'package:perpustakaan_mobile/utils/screen_utils.dart';
import 'package:perpustakaan_mobile/utils/show_utils.dart';
import 'package:perpustakaan_mobile/widget/button/button_component.dart';
import 'package:perpustakaan_mobile/widget/text/text_widget.dart';
import 'package:perpustakaan_mobile/widget/textfield/textfield_component.dart';

import '../../../utils/position.dart';

class Peminjaman extends StatefulWidget {
  const Peminjaman({Key? key}) : super(key: key);

  @override
  State<Peminjaman> createState() => _PeminjamanState();
}

class _PeminjamanState extends State<Peminjaman> {
  FirebaseServices db = FirebaseServices();
  final time = Time();

  final hariController = TextEditingController();

  Future<void> onPerpanjangan(id, int day) async {
    var getDate = time.getDateByRange(day);

    final tanggalPengembalian = "${time.getYear()}-${getDate[1]}-${getDate[0]}";

    await db.update("peminjaman", id, {
      "tanggal_peminjaman": time.getTimeNow(),
      "tanggal_pengembalian": tanggalPengembalian,
    });
  }

  void onClickPerpanjangan(BuildContext context, id) {
    dialogShowCustomContent(
        context: context,
        title: TextWidget("Perpanjangan"),
        content: Container(
          height: 70,
          child: Column(
            children: [
              TextfieldComponent(
                label: "Input Hari",
                inputType: TextInputType.number,
                controller: hariController,
              ),
            ],
          ),
        ),
        actions: [
          ButtonElevatedComponent(
            "Konfirmasi",
            onPressed: () {
              final day = int.parse(hariController.text);
              if (day <= 14) {
                onPerpanjangan(id, day);
                hariController.clear();
                dialogClose(context);
                showToast("Berhasil perpanjangan", Colors.green);
              } else {
                showToast("Perpanjangan tidak boleh dari 14 hari", Colors.red);
              }
            },
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = db.getCurrentUser();

    final query = [ModelQuery(key: "email", value: currentUser?.email)];

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Peminjaman',
            style: TextStyle(color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff0096ff), Color(0xff6610f2)],
                  begin: FractionalOffset.bottomLeft,
                  end: FractionalOffset.bottomRight),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: db.query("peminjaman", query),
            builder: ((context, snapshot) {
              return snapshot.hasData
                  ? SafeArea(
                      child: Container(
                          child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        DocumentSnapshot data = snapshot.data!.docs[index];

                        return ItemCard(data, context);
                      }),
                    )))
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            })));
  }

  Container ItemCard(DocumentSnapshot data, BuildContext context) {
    int sisaHariNow = 0;
    int denda = 0;
    final time = Time();
    bool isTenggat = false;

    void deletePeminjamanOnline() {
      if (data["type_peminjaman"] == "online") {
        db.delete("peminjaman", data.id);
      }
    }

    if (data['konfirmasi']) {
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
        deletePeminjamanOnline();
      } else if (sisaHariNow < 0) {
        if (data["type_peminjaman"] == "online")
          db.delete("peminjaman", data.id);
        sisaHariNow = sisaHariNow.abs();
        isTenggat = true;
        denda = sisaHariNow * 1000;
        deletePeminjamanOnline();
      }
    }

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(bottom: 10),
      // height: 0.40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 3),
        borderRadius: BorderRadius.circular(7),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              V(20),
              Image.network(
                data["image"],
                height: 0.2.h,
                width: 0.2.h,
              ),
              V(16),
              Container(
                // width: 0.34.w,
                color: data['konfirmasi'] ? Colors.green : Colors.red,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: TextWidget(
                    data['konfirmasi'] ? "Konfirmasi" : "Belum konfirmasi",
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              V(16),
              data["konfirmasi"]! && sisaHariNow < 7
                  ? Container(
                      child: ElevatedButton(
                          onPressed: () {
                            onClickPerpanjangan(context, data.id);
                          },
                          child: Text("Perpanjangan")),
                    )
                  : Container(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // V(20),
              TextWidget(
                "Judul buku",
                fontWeight: FontWeight.bold,
              ),
              Container(
                width: 0.5.w,
                color: Colors.grey,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: TextWidget(
                    data['judul_buku'],
                    color: Colors.white,
                  ),
                ),
              ),
              V(8),
              TextWidget(
                "Pengarang",
                fontWeight: FontWeight.bold,
              ),
              Container(
                width: 0.5.w,
                color: Colors.grey,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: TextWidget(
                    data['judul_buku'],
                    color: Colors.white,
                  ),
                ),
              ),
              V(8),
              TextWidget(
                "Nama peminjam",
                fontWeight: FontWeight.bold,
              ),
              Container(
                width: 0.5.w,
                color: Colors.grey,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: TextWidget(
                    data['nama_peminjam'],
                    color: Colors.white,
                  ),
                ),
              ),
              V(8),
              data['konfirmasi']
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          "Sisa hari",
                          fontWeight: FontWeight.bold,
                        ),
                        Container(
                          width: 0.5.w,
                          color: sisaHariNow <= 3
                              ? Colors.yellow
                              : sisaHariNow < 0
                                  ? Colors.red
                                  : Colors.blue,
                          child: Container(
                            margin: EdgeInsets.all(8),
                            child: TextWidget(
                              // data['tanggal_peminjaman'],
                              !isTenggat
                                  ? "$sisaHariNow Hari"
                                  : "Lewat $sisaHariNow Hari",
                              color: Colors.white,
                            ),
                          ),
                        ),
                        V(8),
                        denda > 0 && data['type_peminjaman'] == "offline"
                            ? Column(
                                children: [
                                  TextWidget(
                                    "Denda",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Container(
                                    width: 0.5.w,
                                    color: Colors.blue,
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      child: TextWidget(
                                        // data['tanggal_peminjaman'],
                                        "$denda",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    )
                  : Container()
            ],
          )
        ],
      ),
    );
  }
}