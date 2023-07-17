import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pandabar/main.view.dart';
import 'package:pandabar/model.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:perpustakaan_mobile/ui/dashboard/akun/akun.dart';
import 'package:perpustakaan_mobile/ui/dashboard/home/home.dart';
import 'package:perpustakaan_mobile/ui/dashboard/peminjaman/peminjaman.dart';
import 'package:perpustakaan_mobile/ui/dashboard/pengembalian/pengembalian.dart';
import 'package:perpustakaan_mobile/utils/Utils.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String page = 'Home';

  Future<void> scan() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes =
          await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);

      if (barcodeScanRes != "-1") {
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
          DateTime tanggal_peminjaman = DateTime.now();
          DateTime tanggal_pengembalian = tanggal_peminjaman.add(Duration(days: 14));

          final doc = FirebaseFirestore.instance.collection("peminjaman");

          final json = {
            "email": currentUser!.email,
            "nama_peminjam": user["nama"],
            "tanggal_peminjaman": tanggal_peminjaman,
            "tanggal_pengembalian": tanggal_pengembalian,
            "created_at": tanggal_peminjaman,
            "judul_buku": book["judul_buku"],
            "pengarang": book['pengarang'],
            "barcode": book['barcode'],
            "image": book['image'],
            "sinopsis": book['sinopsis'],
            "halaman": book['halaman'],
            "rak": book['rak'],
            "penerbit": book['penerbit'],
            "kategori": book['kategori'],
            "status": "active"
          };

          await doc.add(json);

          Utils.showSnackBar("Peminjaman Berhasil.", Colors.green);
        } else {
          Utils.showSnackBar("Buku tidak ada dalam database", Colors.red);
        }
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
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
          PandaBarButtonData(id: 'Pengembalian', icon: Icons.book_sharp, title: 'Riwayat'),
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
          scan();
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
