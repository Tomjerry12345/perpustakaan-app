import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan_mobile/model/ModelQuery.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/services/NotificationServices.dart';
import 'package:perpustakaan_mobile/ui/dashboard/data-buku/data_buku.dart';
import 'package:perpustakaan_mobile/utils/Time.dart';
import 'package:perpustakaan_mobile/utils/warna.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final fs = FirebaseServices();

  String search = "";

  @override
  initState() {
    super.initState();
    onNotification();
  }

  Future<void> onNotification() async {
    final user = fs.getCurrentUser();
    final time = Time();
    final res = await fs.queryFuture("peminjaman", [ModelQuery(key: "email", value: user?.email)]);

    if (res.size > 0) {
      res.docs.forEach((e) {
        final data = e.data();

        if (data['konfirmasi']) {
          final tanggalPeminjaman = data['tanggal_pengembalian'].toString().split("-");
          final datePeminjaman = int.parse(tanggalPeminjaman[2]);
          final monthPeminjaman = int.parse(tanggalPeminjaman[1]);
          final yearPeminjaman = int.parse(tanggalPeminjaman[0]);

          int sisaHariNow = time.getJumlahHariDate(yearPeminjaman, monthPeminjaman, datePeminjaman);

          if (sisaHariNow > 0 && sisaHariNow <= 3) {
            NotificationServices.showNotification(
                id: 1,
                title: "Pemberitahuan",
                body:
                    "Sisa $sisaHariNow hari untuk pengembalian buku.Silahkan lakukan perpanjangan!!!",
                payload: "test");
          }
        }
      });
    }
  }

  Future<void> openTalkBackSettings() async {
    const url = 'package:com.google.android.marvin.talkback/com.android.settings.DisplaySettings';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Tidak dapat membuka pengaturan TalkBack';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(children: <Widget>[
          Container(
            child: Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff0096ff), Color(0xff6610f2)],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 50, right: 50),
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            search = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40, left: 50),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Container(
                              height: 50, width: 50, child: Image.asset("assets/images/logo.png")),
                          Wrap(
                            spacing: 5,
                            direction: Axis.vertical,
                            children: [
                              Text(
                                'Perpustakaan Wilayah',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Warna.warnaputi,
                                ),
                              ),
                              Text(
                                'Sulawesi Selatan',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Warna.warnaputi,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     openTalkBackSettings();
                    //   },
                    //   child: Text('Aktifkan TalkBack'),
                    // )

                    // Container(
                    //   margin: EdgeInsets.only(top: 20, left: 36, right: 36),
                    //   height: 100,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(20),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         offset: Offset(0, 10),
                    //         blurRadius: 50,
                    //         color: Colors.blue.withOpacity(0.23),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => const Kategori()),
                    //         );
                    //       },
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Icon(
                    //             Icons.dashboard,
                    //             size: 30,
                    //             color: Colors.blue,
                    //           ),
                    //           Text(
                    //             'Kategori',
                    //             style: TextStyle(
                    //               fontSize: 15,
                    //               color: Warna.warnabiru1,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => const StokBuku()),
                    //         );
                    //       },
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Icon(
                    //             Icons.article,
                    //             size: 30,
                    //             color: Colors.blue,
                    //           ),
                    //           Text(
                    //             'Stok Buku',
                    //             style: TextStyle(
                    //               fontSize: 15,
                    //               color: Warna.warnabiru1,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => const terlaris()),
                    //         );
                    //       },
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Icon(
                    //             Icons.favorite,
                    //             size: 30,
                    //             color: Colors.blue,
                    //           ),
                    //           Text(
                    //             'Favorit',
                    //             style: TextStyle(
                    //               fontSize: 15,
                    //               color: Warna.warnabiru1,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         FirebaseAuth.instance.signOut();
                    //         Utils.showSnackBar("Berhasil logout.", Colors.red);
                    //       },
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Icon(
                    //             Icons.logout,
                    //             size: 30,
                    //             color: Colors.blue,
                    //           ),
                    //           Text(
                    //             'Logout',
                    //             style: TextStyle(
                    //               fontSize: 15,
                    //               color: Warna.warnabiru1,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     )
                    //   ]),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buku',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ],
              )),
          StreamBuilder<QuerySnapshot>(
              // stream:
              //     firestore.collection("books").where("isRecomended", isEqualTo: "1").snapshots(),
              // stream: fs.getAllStream("books"),
              stream: search != ""
                  ? firestore.collection("books").where("judul_buku", isEqualTo: search).snapshots()
                  : fs.getAllStream("books"),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: GridView.builder(
                          physics: const ScrollPhysics(),
                          primary: true,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            DocumentSnapshot data = snapshot.data!.docs[index];
                            return CardBook(data, context);
                          }),
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                            childAspectRatio: MediaQuery.of(context).size.height / 1360,
                          ),
                        ),
                      );
              }),
        ]),
      ),
    );
  }

  Card CardBook(DocumentSnapshot data, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(right: 5, left: 5, top: 5),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => DataBuku(
                          data: data,
                        ))));
          },
          splashColor: Colors.blueAccent,
          child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent, width: 3)),
              child: Center(
                  child: Column(children: [
                Container(
                    height: 200,
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          data["image"],
                          height: 150,
                          width: 150,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              data["judul_buku"],
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data["pengarang"],
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ))
              ])))),
    );
  }
}
