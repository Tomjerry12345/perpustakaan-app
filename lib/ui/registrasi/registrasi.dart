import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan_mobile/main.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/ui/login/login.dart';
import 'package:perpustakaan_mobile/utils/Utils.dart';
import 'package:perpustakaan_mobile/utils/generated_utils.dart';
import 'package:perpustakaan_mobile/utils/position.dart';
import 'package:perpustakaan_mobile/utils/warna.dart';
import 'package:perpustakaan_mobile/widget/avatar/avatar_component.dart';
import 'package:perpustakaan_mobile/widget/form/FormCustom.dart';

class Registrasi extends StatefulWidget {
  const Registrasi({Key? key}) : super(key: key);

  @override
  State<Registrasi> createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final pekerjaanController = TextEditingController();
  final hpController = TextEditingController();
  final namaIbuKandungController = TextEditingController();
  final alamatIbuKandungController = TextEditingController();
  final noHpIbuKandungController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  File? getImage;

  final fs = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    print("test");
    return Scaffold(
        body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 75),
        width: double.infinity,
        child: Text(
          "Registrasi",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, color: Warna.warnabiru1),
        ),
      ),
      SizedBox(
        height: 36,
      ),
      Center(
          child: AvatarComponent(
        "https://www.seekpng.com/png/detail/17-176376_person-free-download-and-person-icon-png.png",
        icon: Icons.camera,
        colorIconBg: Colors.grey,
        onGetImage: (image) {
          setState(() {
            getImage = image;
          });
        },
      )),
      V(32),
      FormCustom(
        text: "nama",
        controller: namaController,
      ),
      SizedBox(
        height: 12,
      ),
      FormCustom(
        text: "alamat",
        controller: alamatController,
      ),
      SizedBox(
        height: 12,
      ),
      FormCustom(
        text: "pekerjaan",
        controller: pekerjaanController,
      ),
      SizedBox(
        height: 12,
      ),
      FormCustom(text: "no.hp", controller: hpController, inputType: TextInputType.number),
      SizedBox(
        height: 12,
      ),
      FormCustom(
        text: "nama ibu kandung",
        controller: namaIbuKandungController,
      ),
      SizedBox(
        height: 12,
      ),
      FormCustom(
        text: "alamat rumah ibu kandung",
        controller: alamatIbuKandungController,
      ),
      SizedBox(
        height: 12,
      ),
      FormCustom(
        text: "no.hp ibu kandung",
        controller: noHpIbuKandungController,
        inputType: TextInputType.number,
      ),
      SizedBox(
        height: 12,
      ),
      FormCustom(
        text: "email",
        controller: emailController,
        inputType: TextInputType.emailAddress,
      ),
      SizedBox(
        height: 12,
      ),
      FormCustom(
        text: "password",
        controller: passwordController,
      ),
      SizedBox(
        height: 12,
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        padding: EdgeInsets.all(3),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 20),
          ),
          child: Text("Daftar"),
          onPressed: () {
            signUp();
          },
        ),
      ),
      SizedBox(height: 20),
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sudah punya akun?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Warna.abutulisan),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
              },
              child: Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Warna.abutulisan,
                ),
              ),
            ),
          ],
        ),
      )
    ]));
  }

  Future signUp() async {
    try {
      if (getImage == null) throw ArgumentError("image belum di pilih");
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final docUser = FirebaseFirestore.instance.collection("users").doc(res.user!.uid);

      final urlFile = await fs.uploadFile(getImage!, "profile");

      final json = {
        "uid": res.user!.uid,
        "nama": namaController.text.trim(),
        "alamat": alamatController.text.trim(),
        "pekerjaan": pekerjaanController.text.trim(),
        "hp": hpController.text.trim(),
        "ibu_kandung": namaIbuKandungController.text.trim(),
        "alamat_ibu_kandung": alamatIbuKandungController.text.trim(),
        "no_hp_ibu_kandung": noHpIbuKandungController.text.trim(),
        "email": emailController.text.trim(),
        "created_at": DateTime.now(),
        "no_anggota": generateRandomString(8),
        "image": urlFile,
      };

      await docUser.set(json);

      Utils.showSnackBar("Berhasil Daftar.", Colors.green);
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('Kode Kesalahan: ${e.code}');
        print('Pesan Kesalahan: ${e.message}');
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Utils.showSnackBar(e.message, Colors.red);
      } else {
        Utils.showSnackBar(e.toString(), Colors.red);
      }
    }
  }
}
