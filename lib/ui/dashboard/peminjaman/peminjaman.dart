import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan_mobile/model/ModelQuery.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/ui/dashboard/peminjaman/section/perpanjangan/perpanjangan.dart';
import 'package:perpustakaan_mobile/utils/Utils.dart';
import 'package:perpustakaan_mobile/utils/screen_utils.dart';
import 'package:perpustakaan_mobile/widget/text/text_widget.dart';

import '../../../utils/position.dart';

class Peminjaman extends StatefulWidget {
  const Peminjaman({Key? key}) : super(key: key);

  @override
  State<Peminjaman> createState() => _PeminjamanState();
}

class _PeminjamanState extends State<Peminjaman> {
  FirebaseServices db = FirebaseServices();

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
                color: Colors.red,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: TextWidget(
                    data['konfirmasi'] ? "Konfirmasi" : "Belum konfirmasi",
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              // ElevatedButton(
              //   style: ButtonStyle(
              //       shape: MaterialStateProperty.all(
              //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
              //   child: Text("Perpanjang"),
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: ((context) => Perpanjangan(
              //                   data: data,
              //                 ))));
              //   },
              // ),
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
                          "Tanggal peminjaman",
                          fontWeight: FontWeight.bold,
                        ),
                        Container(
                          width: 0.5.w,
                          color: Colors.blue,
                          child: Container(
                            margin: EdgeInsets.all(8),
                            child: TextWidget(
                              // data['tanggal_peminjaman'],
                              "test",
                              color: Colors.white,
                            ),
                          ),
                        ),
                        V(8),
                        TextWidget(
                          "Tanggal pengembalian",
                          fontWeight: FontWeight.bold,
                        ),
                        Container(
                          width: 0.5.w,
                          color: Colors.yellow,
                          child: Container(
                            margin: EdgeInsets.all(8),
                            child: TextWidget(
                              // data['tanggal_pengembalian'],
                              "test",
                              color: Colors.white,
                            ),
                          ),
                        )
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
