import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:local_auth/local_auth.dart';
import 'package:perpustakaan_mobile/main.dart';
import 'package:perpustakaan_mobile/services/FirebaseServices.dart';
import 'package:perpustakaan_mobile/ui/registrasi/registrasi.dart';
import 'package:perpustakaan_mobile/utils/Utils.dart';
import 'package:perpustakaan_mobile/utils/position.dart';
import 'package:perpustakaan_mobile/widget/form/FormCustom.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();
  final fs = FirebaseServices();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            V(68),
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Image.asset("assets/images/logo.png"),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "LOGIN",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24,
                  color: HexColor("#017DC3"),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Email",
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FormCustom(
                    text: 'Email',
                    controller: emailController,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    child: const Text(
                      "Password",
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FormCustom(
                    text: 'Password',
                    controller: passwordController,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // Container(
            //   width: double.infinity,
            //   alignment: Alignment.centerRight,
            //   child: TextButton(
            //     child: Text("lupa Password ?"),
            //     style: TextButton.styleFrom(
            //       primary: Colors.blue,
            //     ),
            //     onPressed: () {},
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2BB1EB),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: const Text("Masuk"),
                onPressed: () {
                  signIn();
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Tidak Punya Akun ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Registrasi()),
                      );
                    },
                    child: const Text(
                      "Daftar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Utils.showSnackBar(e.message, Colors.red);
    }
  }
}
