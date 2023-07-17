import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/utils/Time.dart';

import '../../../utils/Utils.dart';

class DataBuku extends StatefulWidget {
  final DocumentSnapshot? data;

  const DataBuku({Key? key, this.data}) : super(key: key);

  @override
  State<DataBuku> createState() => _DataBukuState();
}

class _DataBukuState extends State<DataBuku> {
  final firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: new Center(
            child: Text(
              'Data Buku',
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child:
                Wrap(spacing: 5.0, runSpacing: 4.0, direction: Axis.horizontal, children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 5, right: 10),
                  height: 120,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Image.network(
                        widget.data!["image"],
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        child: Wrap(
                          direction: Axis.vertical,
                          spacing: 10.0,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.print),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(widget.data!["judul_buku"]),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.print),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(widget.data!["pengarang"]),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.print),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(widget.data!["barcode"]),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              Container(),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    width: double.infinity,
                    child: Wrap(
                      children: [
                        Column(
                          children: [
                            Wrap(
                              spacing: 15,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text(
                                    widget.data!["sinopsis"],
                                    style: TextStyle(height: 1.5),
                                  ),
                                  margin: EdgeInsets.only(top: 5),
                                  padding: EdgeInsets.all(8),
                                  height: 130,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Wrap(
                                    spacing: 15,
                                    direction: Axis.vertical,
                                    children: [
                                      Text(
                                        'Tanggal Terbit: ${DateFormat("dd MMMM yyyy").format(widget.data!["tanggal"].toDate())}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Jumlah Halaman: ${widget.data!["halaman"]}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Rak Buku: ${widget.data!["rak"]}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(height: 20),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  width: double.infinity,
                                  padding: EdgeInsets.all(3),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                    ),
                                    child: Text("Pinjam Buku"),
                                    onPressed: () {
                                      print("click");
                                      final time = Time();

                                      var getDate = time.getDateByRange(14);

                                      final tanggalPengembalian =
                                          "${time.getYear()}-${getDate[1]}-${getDate[0]}";

                                      final data = <String, dynamic>{
                                        "nama_peminjam": firebaseServices.getCurrentUser()?.email,
                                        "judul_buku": widget.data!["judul_buku"],
                                        "tanggal_peminjaman": time.getTimeNow(),
                                        "tanggal_pengembalian": tanggalPengembalian,
                                        "image": widget.data!["image"]
                                      };

                                      firebaseServices.add("peminjaman", data);

                                      Utils.showSnackBar("Berhasil", Colors.green);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ])));
  }
}
