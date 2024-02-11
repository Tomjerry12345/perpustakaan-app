import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:perpustakaan_mobile/model/ModelQuery.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/ui/dashboard/bottom_nav.dart';
import 'package:perpustakaan_mobile/ui/login/login.dart';
import 'package:perpustakaan_mobile/utils/Time.dart';
import 'package:perpustakaan_mobile/utils/log_utils.dart';
import 'package:perpustakaan_mobile/utils/navigate_utils.dart';

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
    final time = Time();

    try {
      final dayNow = time.getDate();
      final monthNow = time.getMonth();
      final yearNow = time.getYear();
      final hourNow = time.getHour();
      final minuteNow = time.getMinute();

      final qTamu = await fs.queryFuture("tamu", [
        ModelQuery(key: "tanggal.hari", value: dayNow),
        ModelQuery(key: "tanggal.bulan", value: monthNow),
        ModelQuery(key: "tanggal.tahun", value: yearNow)
      ]);

      if (qTamu.size <= 0) {
        final canAuth = await isAuth();
        if (canAuth) {
          bool authenticated = await auth.authenticate(
            localizedReason:
                "Silahkan masukkan sidik jari anda untuk mengisi buku tamu",
          );
          if (authenticated) {
            final user = fs.getCurrentUser();

            final q = await fs.queryFuture(
                "users", [ModelQuery(key: "email", value: user!.email)]);
            final u = q.docs[0];
            fs.add("tamu", {
              "no_anggota": u["no_anggota"],
              "nama": u["nama"],
              "tanggal": {
                "hari": dayNow,
                "bulan": monthNow,
                "tahun": yearNow,
                "jam": hourNow,
                "menit": minuteNow
              },
              "alamat": u["alamat"],
              "noHp": u["hp"],
              "pekerjaan": u["pekerjaan"]
            });
            navigatePush(const BottomNav(), isRemove: true);
          } else {
            showToast("sidik jari tidak di temukan", Colors.red);
            // FirebaseAuth.instance.signOut();
            // navigatorKey.currentState!.popUntil((route) => route.isFirst);
            navigatePush(const Login(), isRemove: true);
          }
        }
      } else {
        navigatePush(const BottomNav(), isRemove: true);
      }
    } catch (e) {
      log("error", v: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
