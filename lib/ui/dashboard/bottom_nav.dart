import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pandabar/main.view.dart';
import 'package:pandabar/model.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/ui/dashboard/akun/akun.dart';
import 'package:perpustakaan_mobile/ui/dashboard/home/home.dart';
import 'package:perpustakaan_mobile/ui/dashboard/peminjaman/peminjaman.dart';
import 'package:perpustakaan_mobile/ui/dashboard/pengembalian/pengembalian.dart';
import 'package:perpustakaan_mobile/utils/Utils.dart';
import 'package:perpustakaan_mobile/utils/show_utils.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String page = 'Home';

  final fs = FirebaseServices();

  void onScan(BuildContext context) {
    dialogShow(
        context: context,
        widget: SimpleDialog(
          // <-- SEE HERE
          title: const Text('Pilih Menu'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                procesScan("masuk");
                dialogClose(context);
              },
              child: const Text('Scan Masuk'),
            ),
            SimpleDialogOption(
              onPressed: () {
                procesScan("pinjam_buku");
                dialogClose(context);
              },
              child: const Text('Pinjam Buku'),
            ),
            SimpleDialogOption(
              onPressed: () {
                procesScan("verifikasi");
                dialogClose(context);
              },
              child: const Text('Verifikasi'),
            ),
          ],
        ));
  }

  Future<void> procesScan(String type) async {
    String barcodeScanRes;
    try {
      barcodeScanRes =
          await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);

      if (barcodeScanRes != "-1") {
        if (type == "masuk") {
        } else if (type == "pinjam_buku") {
          _onPinjamBuku(barcodeScanRes);
        } else if (type == "verifikasi") {
          _onPinjam(barcodeScanRes);
        }
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  void _onPinjamBuku(String barcodeScanRes) async {
    var books = await FirebaseFirestore.instance
        .collection("books")
        .where("barcode", isEqualTo: barcodeScanRes)
        .get();

    var users = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: currentUser!.email)
        .get();
    var user = users.docs[0];

    if (books.size > 0) {
      var book = books.docs[0];
      // DateTime tanggalPeminjaman = DateTime.now();
      // DateTime tanggalPengembalian = tanggalPeminjaman.add(const Duration(days: 14));

      final doc = FirebaseFirestore.instance.collection("peminjaman");

      final json = {
        "nama_peminjam": user["nama"],
        "email": currentUser!.email,
        "judul_buku": book["judul_buku"],
        "pengarang": book["pengarang"],
        "image": book["image"],
        "rak": book["rak"],
        "konfirmasi": false
        // "email": currentUser!.email,
        // "nama_peminjam": user["nama"],
        // "tanggal_peminjaman": tanggalPeminjaman,
        // "tanggal_pengembalian": tanggalPengembalian,
        // "created_at": tanggalPeminjaman,
        // "judul_buku": book["judul_buku"],
        // "pengarang": book['pengarang'],
        // "barcode": book['barcode'],
        // "image": book['image'],
        // "sinopsis": book['sinopsis'],
        // "halaman": book['halaman'],
        // "rak": book['rak'],
        // "penerbit": book['penerbit'],
        // "kategori": book['kategori'],
        // "status": "active"
      };

      await doc.add(json);

      Utils.showSnackBar("Peminjaman Berhasil.", Colors.green);
    } else {
      Utils.showSnackBar("Buku tidak ada dalam database", Colors.red);
    }
  }

  Future<void> _onPinjam(String barcodeScanRes) async {
    if (barcodeScanRes == "default") {
      await fs.update("barcode", "code", {"code": "peminjaman-${currentUser!.email}"});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: PandaBar(
        backgroundColor: Colors.white,
        buttonData: [
          PandaBarButtonData(id: 'Home', icon: Icons.home, title: 'Home'),
          PandaBarButtonData(id: 'Peminjaman', icon: Icons.book_online, title: 'Peminjaman'),
          PandaBarButtonData(id: 'Pengembalian', icon: Icons.book_sharp, title: 'Pengembalian'),
          PandaBarButtonData(
            id: 'Akun',
            icon: Icons.account_box,
            title: 'Akun',
          ),
        ],
        onChange: (id) {
          setState(() {
            page = id;
          });
        },
        onFabButtonPressed: () {
          onScan(context);
        },
        fabIcon: Icon(
          Icons.qr_code,
          color: Colors.white,
        ),
      ),
      body: Builder(
        builder: (context) {
          switch (page) {
            case 'Home':
              return const Home();
            case 'Peminjaman':
              return const Peminjaman();
            case 'Pengembalian':
              return const Pengembalian();
            case 'Akun':
              return const Akun();
            default:
              return Container();
          }
        },
      ),
    );
  }
}
