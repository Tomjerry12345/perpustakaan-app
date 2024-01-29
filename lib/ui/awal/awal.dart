import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perpustakaan_mobile/main.dart';
// import 'package:perpustakaan_mobile/main.dart';

class Awal extends StatefulWidget {
  const Awal({Key? key}) : super(key: key);

  @override
  State<Awal> createState() => _AwalState();
}

class _AwalState extends State<Awal> {
  // final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 150,
              height: 100,
            ),
            const Text(
              'LIBRARY SULSEL',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
