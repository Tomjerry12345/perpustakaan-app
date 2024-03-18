import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan_mobile/model/ModelQuery.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/ui/dashboard/data-buku/section/view-pdf/view_pdf.dart';
import 'package:perpustakaan_mobile/utils/Time.dart';
import 'package:perpustakaan_mobile/utils/log_utils.dart';
import 'package:perpustakaan_mobile/utils/navigate_utils.dart';
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

  void onBacaBuku(DocumentSnapshot<Object?> documenSnapshot) {
    final data = documenSnapshot.data() as Map<String, dynamic>;
    log("data", v: data);
    navigatePush(
        ViewPdf(path: data["buku"], judul: data["judul_buku"], isPinjam: true));
  }

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
        title: const TextWidget("Perpanjangan"),
        content: SizedBox(
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
              if (day <= 7) {
                onPerpanjangan(id, day);
                hariController.clear();
                dialogClose(context);
                showToast("Berhasil perpanjangan", Colors.green);
              } else {
                showToast("Perpanjangan tidak boleh dari 7 hari", Colors.red);
              }
            },
            bg: Colors.blue,
          )
        ]);
  }

  void onPengembalian(DocumentSnapshot<Object?> documenSnapshot) {
    final id = documenSnapshot.id;
    final data = documenSnapshot.data() as Map<String, dynamic>;
    db.add("pengembalian", {
      "email": data["email"],
      "nama_peminjam": data["nama_peminjam"],
      "judul_buku": data["judul_buku"],
      "pengarang": data["pengarang"],
      "tanggal_peminjaman": data["tanggal_peminjaman"],
      "tanggal_pengembalian": time.getTimeNow(),
      "type_peminjaman": data["type_peminjaman"],
      "denda": null,
      "sisa_hari": null,
      "image": data["image"],
    });
    oHapus(id);
  }

  void oHapus(String id) {
    db.delete("peminjaman", id);
    navigatePop();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = db.getCurrentUser();

    final query = [ModelQuery(key: "email", value: currentUser?.email)];

    return Scaffold(
        appBar: AppBar(
          title: const Text(
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
                      child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        DocumentSnapshot data = snapshot.data!.docs[index];

                        return ItemCard(data, context);
                      }),
                    ))
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            })));
  }

  // ignore: non_constant_identifier_names
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
        if (data["type_peminjaman"] == "online") {
          db.delete("peminjaman", data.id);
        }
        sisaHariNow = sisaHariNow.abs();
        isTenggat = true;
        denda = sisaHariNow * 1000;
        deletePeminjamanOnline();
      }
    }

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(bottom: 10),
      // height: 0.40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 3),
        borderRadius: BorderRadius.circular(7),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              V(10),
              Image.network(
                data["image"],
                height: 0.2.h,
                width: 0.2.h,
              ),
              V(16),
              data["type_peminjaman"] == "offline"
                  ? Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: data['konfirmasi'] ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Container(
                          margin: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              TextWidget(
                                data['konfirmasi']
                                    ? "Konfirmasi"
                                    : "Belum konfirmasi",
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              data['konfirmasi']
                                  ? Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    )
                            ],
                          )),
                    )
                  : Container(),
              data["type_peminjaman"] == "online"
                  ? ElevatedButton.icon(
                      icon: Icon(
                        Icons.assignment_return,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        AlertDialog alert = AlertDialog(
                          title: const Text("Pengembalian"),
                          content: const Text(
                              "Apakah anda yakin ingin mengembalikan buku?"),
                          actions: [
                            ElevatedButton(
                                onPressed: () async {
                                  onPengembalian(data);
                                },
                                child: const Text("Ok")),
                            ElevatedButton(
                                onPressed: () {
                                  navigatePop();
                                },
                                child: const Text("Batal")),
                          ],
                        );
                        dialogShow(context: context, widget: alert);
                      },
                      label: const Text(
                        "Pengembalian",
                        style: TextStyle(color: Colors.white),
                      ))
                  : Container(),
              V(16),
              data["type_peminjaman"] == "online"
                  ? SizedBox(
                      // width: 124,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            onBacaBuku(data);
                          },
                          icon: Icon(
                            Icons.menu_book,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Baca buku",
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  : Container(),
            ],
          ),
          H(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              V(16),
              const TextWidget(
                "Judul buku",
                fontWeight: FontWeight.bold,
              ),
              Container(
                width: 0.48.w,
                color: Colors.grey,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: TextWidget(
                    data['judul_buku'],
                    color: Colors.white,
                  ),
                ),
              ),
              V(8),
              const TextWidget(
                "Pengarang",
                fontWeight: FontWeight.bold,
              ),
              Container(
                width: 0.48.w,
                color: Colors.grey,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: TextWidget(
                    data['judul_buku'],
                    color: Colors.white,
                  ),
                ),
              ),
              V(8),
              const TextWidget(
                "Nama peminjam",
                fontWeight: FontWeight.bold,
              ),
              Container(
                width: 0.48.w,
                color: Colors.grey,
                child: Container(
                  margin: const EdgeInsets.all(8),
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
                        const TextWidget(
                          "Sisa hari",
                          fontWeight: FontWeight.bold,
                        ),
                        Container(
                          width: 0.48.w,
                          color: sisaHariNow <= 3
                              ? Colors.grey
                              : sisaHariNow < 0
                                  ? Colors.red
                                  : Colors.grey,
                          child: Container(
                            margin: const EdgeInsets.all(8),
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
                                  const TextWidget(
                                    "Denda",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Container(
                                    width: 0.5.w,
                                    color: Colors.blue,
                                    child: Container(
                                      margin: const EdgeInsets.all(8),
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
                  : Container(),
              V(12),
              data["konfirmasi"]! && sisaHariNow < 3
                  ? ButtonElevatedComponent(
                      "Perpanjangan",
                      onPressed: () {
                        onClickPerpanjangan(context, data.id);
                      },
                      bg: Colors.blue,
                      radius: 50,
                      h: 48,
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}
