import 'package:stroop_effect/pages/authentication/login.dart';
import 'package:stroop_effect/pages/authentication/register.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterPage extends StatefulWidget {
  LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showRegisterPage = true;

  void togglePages() {
    setState(() {
      showRegisterPage = !showRegisterPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showRegisterPage) {
      return RegisterPage(
        onTap: togglePages,
      );
    } else {
      return LoginPage(
        onTap: togglePages,
      );
    }
  }
}
