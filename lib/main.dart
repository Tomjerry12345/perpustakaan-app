import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan_mobile/firebase_options.dart';
import 'package:perpustakaan_mobile/model/ModelQuery.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/services/NotificationServices.dart';
import 'package:perpustakaan_mobile/ui/awal/awal.dart';
import 'package:perpustakaan_mobile/ui/dashboard/bottom_nav.dart';
import 'package:perpustakaan_mobile/ui/login/login.dart';
import 'package:perpustakaan_mobile/utils/Time.dart';
import 'package:perpustakaan_mobile/utils/Utils.dart';
import 'package:perpustakaan_mobile/utils/show_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationServices.initNotification();

  sendNotif();

  NotificationServices.scheduleNotification(
      id: 0,
      title: "Pemberitahuan",
      body:
          "Buku dengan judul testing telah mendekati batas peminjaman!Silahkan lakukan perpanjangan sebelum mencapai batas waktu",
      payload: "luffy");

  runApp(const MyApp());
}

void sendNotif() async {
  FirebaseServices db = FirebaseServices();

  final currentUser = db.getCurrentUser();

  final query = [ModelQuery(key: "nama_peminjam", value: currentUser?.email)];

  final data = await db.queryFuture("peminjaman", query);

  var i = 0;

  for (var element in data.docs) {
    final d = element.data();

    final tanggal = d["tanggal_pengembalian"].toString().split("-");

    Time time = Time();

    final getDate = time.getDateBeforeByRange(tanggal[2], 3);

    logO("date", getDate);

    if (time.getYear() == int.parse(tanggal[0])) {
      if (time.getMonth() == int.parse(tanggal[1])) {
        if (getDate >= time.getDate() && time.getDate() <= int.parse(tanggal[2])) {
          NotificationServices.scheduleNotification(
              id: i,
              title: "Pemberitahuan",
              body:
                  "Buku dengan judul ${d["title"]} telah mendekati batas peminjaman!Silahkan lakukan perpanjangan sebelum mencapai batas waktu",
              payload: d["nama_peminjam"]);
        } else {
          NotificationServices.removeNotification(i);
        }
      }
    }

    i += 1;
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      home: Awal(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return BottomNav();
              } else {
                return Login();
              }
            }),
      );
}
