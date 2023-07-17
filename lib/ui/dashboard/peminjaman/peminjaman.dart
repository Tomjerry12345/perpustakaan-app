import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan_mobile/model/ModelQuery.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/ui/dashboard/peminjaman/section/perpanjangan/perpanjangan.dart';
import 'package:perpustakaan_mobile/utils/Utils.dart';

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

    final query = [ModelQuery(key: "nama_peminjam", value: currentUser?.email)];

    return Scaffold(
        appBar: AppBar(
          title: Text("Peminjaman"),
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
    final firebaseServices = FirebaseServices();
    return Container(
        margin: EdgeInsets.all(10),
        height: 295,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(7),
          color: Colors.white,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Wrap(spacing: 8.0, direction: Axis.horizontal, children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Image.network(
                        data["image"],
                        height: 150,
                        width: 150,
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Wrap(
                              spacing: 10,
                              direction: Axis.vertical,
                              children: [
                                Container(
                                  width: 150,
                                  child: Text(
                                    "Nama peminjam: ${data['nama_peminjam']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    "Judul buku: ${data['judul_buku']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    "Tanggal peminjaman: ${data['tanggal_peminjaman']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    "Tanggal pengembalian: ${data['tanggal_pengembalian']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                // Text(
                                //   data['barcode'],
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     color: Colors.black,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => Perpanjangan(
                                        data: data,
                                      ))));
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 160,
                      height: 70,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                        child: Text("Pengembalian"),
                        onPressed: () {
                          print("data: ${data.id}");
                          final listData = <String, dynamic>{
                            "nama_peminjam": data['nama_peminjam'],
                            "judul_buku": data['judul_buku'],
                            "image": data["image"]
                          };

                          firebaseServices.add("pengembalian", listData);
                          firebaseServices.delete("peminjaman", data.id);
                          Utils.showSnackBar("Berhasil", Colors.green);
                        },
                      ),
                    ),
                  ],
                ),
              ]))
        ]));
  }
}
