import 'package:flutter/material.dart';

enum TypeTextField { input, password }

class InputTextfield extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TypeTextField type;
  const InputTextfield(
      {super.key,
      this.hintText,
      this.controller,
      this.type = TypeTextField.input});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
      ),
    );
  }
}

class PasswordTextfield extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TypeTextField type;
  const PasswordTextfield(
      {super.key,
      this.hintText,
      this.controller,
      this.type = TypeTextField.input});

  @override
  State<PasswordTextfield> createState() => _PasswordTextfieldState();
}

class _PasswordTextfieldState extends State<PasswordTextfield> {
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: passwordVisible,
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: widget.hintText,
        suffixIcon: IconButton(
          icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(
              () {
                passwordVisible = !passwordVisible;
              },
            );
          },
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
    );
  }
}

class TextfieldComponent extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TypeTextField type;
  const TextfieldComponent(
      {super.key,
      this.hintText,
      this.controller,
      this.type = TypeTextField.input});

  @override
  Widget build(BuildContext context) {
    return type == TypeTextField.input
        ? InputTextfield(
            hintText: hintText,
            controller: controller,
          )
        : PasswordTextfield(hintText: hintText, controller: controller);
  }
}
