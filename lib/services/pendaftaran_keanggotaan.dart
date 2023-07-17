import 'package:flutter/material.dart';
import 'package:perpustakaan_mobile/widget/form/FormCustom.dart';

class Pendaftaran extends StatefulWidget {
  const Pendaftaran({Key? key}) : super(key: key);

  @override
  State<Pendaftaran> createState() => _PendaftaranState();
}

class _PendaftaranState extends State<Pendaftaran> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final namaController = TextEditingController();
  final alamatController = TextEditingController();

  final pekerjaanController = TextEditingController();
  final hpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(top: 75),
              width: double.infinity,
              child: Text(
                "Registrasi",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: Colors.blueAccent),
              ),
            ),
            SizedBox(
              height: 36,
            ),
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
            FormCustom(
              text: "no.hp",
              controller: hpController,
            ),
            SizedBox(
              height: 12,
            ),
            FormCustom(
              text: "email",
              controller: emailController,
            ),
            SizedBox(
              height: 12,
            ),
            FormCustom(
              text: "password",
              controller: passwordController,
            ),
          ])),
    );
  }
}
