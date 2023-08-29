import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';

class Pengembalian extends StatefulWidget {
  const Pengembalian({Key? key}) : super(key: key);

  @override
  State<Pengembalian> createState() => _PengembalianState();
}

class _PengembalianState extends State<Pengembalian> {
  final frebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pengembalian',
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
            stream: frebaseServices.getAllStream("pengembalian"),
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
        height: 150,
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
                  margin: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Image.network(
                        data["image"],
                        height: 100,
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10, left: 20),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Container(
                //       margin: EdgeInsets.only(top: 10),
                //       width: 180,
                //       height: 70,
                //       padding: EdgeInsets.all(15),
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(40),
                //       ),
                //       child: ElevatedButton(
                //         style: ButtonStyle(
                //             backgroundColor:
                //                 MaterialStateProperty.all(Colors.red),
                //             shape: MaterialStateProperty.all(
                //                 RoundedRectangleBorder(
                //                     borderRadius:
                //                         BorderRadius.circular(50)))),
                //         child: Text("Kembalikan Buku"),
                //         onPressed: () {
                //           // print("data: ${data.id}");
                //           // final listData = <String, dynamic>{
                //           //   "nama_peminjam": data['nama_peminjam'],
                //           //   "judul_buku": data['judul_buku'],
                //           //   "image": data["image"]
                //           // };

                //           // firebaseServices.add("pengembalian", listData);
                //           // firebaseServices.delete("peminjaman", data.id);
                //           // Utils.showSnackBar("Berhasil", Colors.green);
                //         },
                //       ),
                //     ),
                //   ],
                // ),
              ]))
        ]));
  }
}
