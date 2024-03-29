import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:admin_perpustakaan/services/FirebaseServices.dart';
import 'package:admin_perpustakaan/utils/position.dart';
import 'package:admin_perpustakaan/utils/screen_utils.dart';
import 'package:admin_perpustakaan/widget/dialog/dialog_widget.dart';
import 'package:admin_perpustakaan/widget/header/header_widget.dart';

import '../../model/ModelQuery.dart';
import '../../widget/text/text_widget.dart';
import 'section/scan_peminjaman.dart';

class Scan extends StatefulWidget {
  const Scan({Key? key}) : super(key: key);

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  final fs = FirebaseServices();

  Future<void> typeMasuk(context, id) async {
    final res =
        await fs.queryFuture("users", [ModelQuery(key: "email", value: id)]);

    bool found = res.size > 0;

    Future.delayed(Duration.zero, () async {
      await dialogShow(
          context: context,
          widget: SizedBox(
            width: 0.4.w,
            height: found ? 0.8.h : 0.7.h,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 0.4.w,
                      height: found ? 0.6.h : 0.48.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ExactAssetImage(found
                                  ? 'assets/success.jpg'
                                  : 'assets/error.jpg'),
                              fit: BoxFit.cover))),
                  V(16),
                  TextWidget(
                    found ? "Akun terdaftar" : "Akun belum terdaftar",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: found ? Colors.black : Colors.red,
                  ),
                  V(16),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await fs
                              .update("barcode", "code", {"code": "default"});
                          dialogClose(context);
                        } catch (e) {
                          context.showFastSnackbar(e.toString(), Colors.red);
                        }
                      },
                      child: const Text("Kembali"))
                ]),
          ));
    });
  }

  Widget widgetMain(code) {
    return Column(
      children: [
        const HeaderWidget(
          title: "Qr code",
        ),
        QrImageView(
          data: code,
          version: QrVersions.auto,
          size: 300.0,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: fs.getAllStream("barcode"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final code = snapshot.data!.docs[0].data()["code"];

            if (code == "default") {
              return widgetMain(code);
            }

            final split = code.toString().split("-");
            final type = split[0];
            final id = split[1];

            if (type == "masuk") {
              typeMasuk(context, id);
            } else if (type == "peminjaman") {
              return ScanPeminjaman(id: id);
            }

            return widgetMain(code);
          }

          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
