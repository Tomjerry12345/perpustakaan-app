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
        child: Container(
          child: Column(
            children: [
              V(68),
              Container(
                width: double.infinity,
                height: 100,
                child: Image.asset("assets/images/logo.png"),
              ),
              SizedBox(
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
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Email",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    FormCustom(
                      text: 'Email',
                      controller: emailController,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: Text(
                        "Password",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    FormCustom(
                      text: 'Password',
                      controller: passwordController,
                    )
                  ],
                ),
              ),
              SizedBox(
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
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff2BB1EB),
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: Text("Masuk"),
                  onPressed: () {
                    signIn();
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
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
                      child: Text(
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
      ),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
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
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Utils.showSnackBar(e.message, Colors.red);
    }
  }
}
