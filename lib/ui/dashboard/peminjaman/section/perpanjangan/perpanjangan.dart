import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/utils/Time.dart';
import 'package:perpustakaan_mobile/utils/Utils.dart';

class Perpanjangan extends StatefulWidget {
  final DocumentSnapshot? data;

  const Perpanjangan({Key? key, this.data}) : super(key: key);

  @override
  State<Perpanjangan> createState() => _PerpanjanganState();
}

class _PerpanjanganState extends State<Perpanjangan> {
  final firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        title: new Center(
          child: Text(
            'Perpanjangan',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff0096ff), Color(0xff6610f2)],
                begin: FractionalOffset.bottomLeft,
                end: FractionalOffset.bottomRight),
          ),
        ),
      ),
      body: Container(
          margin: EdgeInsets.only(top: 10),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Wrap(
                spacing: 8.0,
                direction: Axis.horizontal,
                children: <Widget>[
                  Center(
                    child: Image.network(
                      widget.data!["image"],
                      width: 180,
                      // height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Wrap(
                      spacing: 10,
                      direction: Axis.vertical,
                      children: [
                        Container(
                          width: 250,
                          child: Text(
                            "Judul buku: ${widget.data!['judul_buku']}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: Text(
                            "Nama peminjam: ${widget.data!['nama_peminjam']}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // Text(
                        //   'Nomor Buku',
                        //   style: TextStyle(
                        //     fontSize: 10,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        Container(
                          width: 250,
                          child: Text(
                            "Tanggal peminjaman: ${widget.data!['tanggal_peminjaman']}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          width: 250,
                          child: Text(
                            "Tanggal pengembalian: ${widget.data!['tanggal_pengembalian']}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 140,
                  height: 70,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                    child: Text("Perpanjang"),
                    onPressed: () async {
                      final id = widget.data!.id;
                      var tanggalPengembalian = widget.data!['tanggal_pengembalian'];
                      final split = tanggalPengembalian.toString().split("-");

                      final time = Time();

                      var getDate = time.getDateByRangeIndex(14, int.parse(split[2]));

                      // final tanggalPengembalian =
                      //     "${time.getYear()}-${time.getMonth()}-$getDate";

                      var month = int.parse(split[1]) + getDate[1];

                      if (month > 12) {
                        month = 1;
                      }

                      tanggalPengembalian = "${split[0]}-${month}-${getDate[0]}";

                      print(tanggalPengembalian);

                      final data = <String, dynamic>{
                        "nama_peminjam": widget.data!['nama_peminjam'],
                        "judul_buku": widget.data!["judul_buku"],
                        "tanggal_peminjaman": widget.data!['tanggal_peminjaman'],
                        "tanggal_pengembalian": tanggalPengembalian,
                        "image": widget.data!["image"]
                      };

                      await firebaseServices.update("peminjaman", id, data);

                      Utils.showSnackBar("Berhasil", Colors.green);

                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ])),
    );
  }
}
