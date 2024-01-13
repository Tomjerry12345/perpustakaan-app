import 'package:admin_perpustakaan/screens/dashboard_screen.dart';
import 'package:admin_perpustakaan/services/FirebaseServices.dart';
import 'package:admin_perpustakaan/utils/navigate_utils.dart';
import 'package:admin_perpustakaan/utils/position.dart';
import 'package:admin_perpustakaan/utils/screen_utils.dart';
import 'package:admin_perpustakaan/widget/button/button_elevated_widget.dart';
import 'package:admin_perpustakaan/widget/text/text_widget.dart';
import 'package:admin_perpustakaan/widget/textfield/textfield_component.dart';
import 'package:fast_snackbar/fast_snackbar.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final fs = FirebaseServices();
    final emailController = TextEditingController();
    final passController = TextEditingController();

    return Scaffold(
      body: Container(
        color: Colors.blue.shade700,
        child: Center(
          child: Container(
            width: 0.3.w,
            height: 0.5.h,
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(children: [
                  Center(
                      child: TextWidget(
                    "Masuk",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
                  V(8),
                  TextWidget("Silahkan login terlebih dahulu"),
                  V(48),
                  TextfieldComponent(
                    hintText: "Email",
                    controller: emailController,
                  ),
                  V(24),
                  TextfieldComponent(
                    hintText: "Password",
                    controller: passController,
                    type: TypeTextField.password,
                  ),
                  V(32),
                  Container(
                    width: 100,
                    child: ButtonElevatedWidget(
                      "Masuk",
                      onPressed: () async {
                        try {
                          final emailTxt = emailController.text;
                          final passTxt = passController.text;
                          print("$emailTxt => $passTxt");
                          await fs.signInWithEmailAndPassword(
                              emailTxt, passTxt);
                          navigatePush(DashboardScreen());
                        } catch (e) {
                          context.showFastSnackbar("$e",
                              color: TypeFastSnackbar.error);
                        }
                      },
                      backgroundColor: Colors.blue,
                    ),
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
