import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:perpustakaan_mobile/ui/dashboard/akun/kartu_perpus/kartu_perpus.dart';

class Akun extends StatelessWidget {
  const Akun({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void displayPdf() async {
      final doc = pw.Document();

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
                            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                          )
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            "SMP NEGERI 6 BULUKUMBA",
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
                        color: pdf.PdfColor(0.9, 0, 0.1),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text("No.Anggota : 555"),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Text("Nama : Selvi Angrgreani"),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Text("Kelas : 2"),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Text("TTL : Bulukumba"),
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
        body: Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: ListView(
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Center(
                    child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.blue,
                      child: Text("P", style: TextStyle(fontSize: 24)),
                      // child: Container(
                      //   width: 200,
                      //   height: 200,
                      //   color: Colors.blue,
                      // ),
                    ),
                  ],
                )),
                SizedBox(
                  height: 18,
                ),
                Center(
                  child: Text("Selvi", style: TextStyle(fontSize: 24)),
                ),
                SizedBox(
                  height: 18,
                ),
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      displayPdf();
                    },
                    child: Text("Lihat kartu perpustakaan"),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    width: 200,
                    height: 308,
                    color: Colors.blue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Data(
                          title: "Nama Lengkap",
                          value: "Selvi anggreani",
                          x: 8,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Data(
                          title: "Alamat",
                          value: "Selvi anggreani",
                          x: 74,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Data(
                          title: "No.Hp",
                          value: "085753845575",
                          x: 84,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Data(
                          title: "Pekerjaan",
                          value: "Nolep",
                          x: 56,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Data(
                          title: "Ibu Kandung",
                          value: "Test",
                          x: 34,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Data(
                          title: "No.Hp Ibu",
                          value: "0865754346876",
                          x: 34,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Data(
                          title: "Alamat Ibu",
                          value: "test",
                          x: 34,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )));
  }

  Row Data({String title = "", String value = "", double x = 0.0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(
          width: x,
        ),
        Text(
          ":",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
              fontSize: 18, fontWeight: pw.FontWeight.bold, color: pdf.PdfColor(1, 1, 1)),
        ),
        pw.SizedBox(
          width: x,
        ),
        pw.Text(
          ":",
          style: pw.TextStyle(
              fontSize: 18, fontWeight: pw.FontWeight.bold, color: pdf.PdfColor(1, 1, 1)),
        ),
        pw.SizedBox(
          width: 8,
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
              fontSize: 18, fontWeight: pw.FontWeight.bold, color: pdf.PdfColor(1, 1, 1)),
        )
      ],
    );
  }
}
