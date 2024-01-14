import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:perpustakaan_mobile/model/ModelQuery.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/ui/dashboard/akun/kartu_perpus/kartu_perpus.dart';
import 'package:perpustakaan_mobile/ui/login/login.dart';
import 'package:perpustakaan_mobile/utils/Utils.dart';
import 'package:perpustakaan_mobile/utils/navigate_utils.dart';
import 'package:printing/printing.dart';

class Akun extends StatefulWidget {
  const Akun({Key? key}) : super(key: key);

  @override
  State<Akun> createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  final fs = FirebaseServices();

  // @override
  // void initState() {
  //   super.initState();
  // }

  // void getData() {

  // }

  @override
  Widget build(BuildContext context) {
    User? user = fs.getCurrentUser();

    void displayPdf(data) async {
      final doc = pw.Document();

      final provider = await flutterImageProvider(NetworkImage(data["image"]));

      doc.addPage(pw.Page(
          pageFormat: pdf.PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
              width: 500,
              height: 200,
              color: pdf.PdfColor(0.6, 1, 0.3),
              child: pw.Column(children: [
                pw.Container(
                  height: 78,
                  width: 500,
                  color: pdf.PdfColor(0.8, 1, 0),
                  child: pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Container(
                            height: 50,
                            width: 50,
                            color: pdf.PdfColor(0.8, 0.9, 1),
                          ),
                          pw.SizedBox(
                            width: 8,
                          ),
                          pw.Text(
                            "Kartu Perpustakaan",
                            style: pw.TextStyle(
                                fontSize: 24, fontWeight: pw.FontWeight.bold),
                          )
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            "No.Anggota ${data["no_anggota"]}",
                            style: pw.TextStyle(
                              fontSize: 12,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 70,
                        height: 100,
                        // color: pdf.PdfColor(0.9, 0, 0.1),
                        child: pw.Image(provider),
                      ),
                      pw.Container(width: 16),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text("Nama : ${data["nama"]}"),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Text("Pekerjaan : ${data["pekerjaan"]}"),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Text("No hp : ${data["hp"]}"),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Text("Alamat : ${data["alamat"]}"),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ]),
            );
          }));

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KartuPerpus(doc: doc),
          ));
    }

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
          title: Center(
            child: Text(
              'Profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Utils.showSnackBar("Berhasil logout.", Colors.red);
                navigatePush(Login(), isRemove: true);
              },
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
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: fs
                .query("users", [ModelQuery(key: "email", value: user!.email)]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final docs = snapshot.data!.docs[0];
                final data = docs.data();
                print(data);
                return Container(
                    padding: EdgeInsets.only(left: 30, top: 20, right: 30),
                    child: ListView(
                      children: [
                        // Text(
                        //   "Profile",
                        //   style: TextStyle(
                        //     fontSize: 20,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 32,
                        // ),
                        Center(
                            child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.blue,
                              backgroundImage: data["image"] != null
                                  ? NetworkImage(data["image"])
                                  : null,
                              child: data["image"] == null
                                  ? Text(data["nama"][0],
                                      style: TextStyle(fontSize: 24))
                                  : null,
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 18,
                        ),
                        Center(
                          child: Text(data["nama"],
                              style: TextStyle(fontSize: 24)),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Center(
                          child: OutlinedButton(
                            onPressed: () {
                              displayPdf(data);
                            },
                            child: Text("Lihat kartu perpustakaan"),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16.0)),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            width: 200,
                            height: 304,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xff0096ff),
                                    Color(0xff6610f2)
                                  ],
                                  begin: FractionalOffset.bottomLeft,
                                  end: FractionalOffset.bottomRight),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Data(
                                  title: "No.anggota",
                                  value: data["no_anggota"],
                                  x: 16,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Data(
                                  title: "Email",
                                  value: data["email"],
                                  x: 16,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Data(
                                  title: "Alamat",
                                  value: data["alamat"],
                                  x: 16,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Data(
                                  title: "No.Hp",
                                  value: data["hp"],
                                  x: 16,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Data(
                                  title: "Pekerjaan",
                                  value: data["pekerjaan"],
                                  x: 16,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Data(
                                  title: "Ibu Kandung",
                                  value: data["ibu_kandung"],
                                  x: 16,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Data(
                                  title: "No.Hp Ibu",
                                  value: data["no_hp_ibu_kandung"],
                                  x: 16,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Data(
                                  title: "Alamat Ibu",
                                  value: data["alamat_ibu_kandung"],
                                  x: 16,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ));
              }

              return Center(child: CircularProgressIndicator());
            }));
  }

  Row Data({String title = "", String value = "", double x = 0.0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(
          width: x,
        ),
        Text(
          ":",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        )
      ],
    );
  }

  pw.Row DataPrint({String title = "", String value = "", double x = 0.0}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: pdf.PdfColor(1, 1, 1)),
        ),
        pw.SizedBox(
          width: x,
        ),
        pw.Text(
          ":",
          style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: pdf.PdfColor(1, 1, 1)),
        ),
        pw.SizedBox(
          width: 8,
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: pdf.PdfColor(1, 1, 1)),
        )
      ],
    );
  }
}
