// import 'package:admin_perpustakaan/screens/autentikasi/login/login.dart';
import 'package:admin_perpustakaan/screens/dashboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:admin_perpustakaan/utils/global_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDDUC9yClvRQ5A-SgogIO9pge6zHtQ6-yM",
          authDomain: "perpustakaan-ccad6.firebaseapp.com",
          projectId: "perpustakaan-ccad6",
          storageBucket: "perpustakaan-ccad6.appspot.com",
          messagingSenderId: "735594420343",
          appId: "1:735594420343:web:979af67336cd3aeda78e72",
          measurementId: "G-FQMKPRX985"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: Login(),
      home: DashboardScreen(),
      navigatorKey: navigatorKey,
    );
  }
}
