import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:perpustakaan_mobile/main.dart';
import 'package:perpustakaan_mobile/model/ModelQuery.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/ui/dashboard/bottom_nav.dart';
import 'package:perpustakaan_mobile/utils/Time.dart';
import 'package:perpustakaan_mobile/utils/log_utils.dart';
import 'package:perpustakaan_mobile/utils/navigate_utils.dart';
import 'package:perpustakaan_mobile/utils/show_utils.dart';

class FaceAutentikasi extends StatefulWidget {
  const FaceAutentikasi({super.key});

  @override
  State<FaceAutentikasi> createState() => _FaceAutentikasiState();
}

class _FaceAutentikasiState extends State<FaceAutentikasi> {
  final LocalAuthentication auth = LocalAuthentication();
  final fs = FirebaseServices();

  @override
  void initState() {
    super.initState();
    onAuth();
  }

  Future<bool> isAuth() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<void> onAuth() async {
    try {
      final canAuth = await isAuth();
      if (canAuth) {
        bool authenticated = await auth.authenticate(
            localizedReason: "Silahkan masukkan sidik jari anda untuk mengisi buku tamu",
            );
        if (authenticated) {
          final user = fs.getCurrentUser();
          final time = Time();
          final q = await fs.queryFuture(
              "users", [ModelQuery(key: "email", value: user!.email)]);
          final u = q.docs[0];
          fs.add("tamu", {
            "no_anggota": u["no_anggota"],
            "nama": u["nama"],
            "tanggal": time.getTimeNowHour(),
            "alamat": u["alamat"],
            "noHp": u["hp"],
            "pekerjaan": u["pekerjaan"]
          });
          navigatePush(BottomNav(), isRemove: true);
        } else {
          showToast("sidik jari tidak di temukan", Colors.red);
          FirebaseAuth.instance.signOut();
          navigatorKey.currentState!.popUntil((route) => route.isFirst);
        }
      } else {
        showToast("device tidak di dukung", Colors.red);
        FirebaseAuth.instance.signOut();
        navigatorKey.currentState!.popUntil((route) => route.isFirst);
      }
    } catch (e) {
      logO("error", e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
