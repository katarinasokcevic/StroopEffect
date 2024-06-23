import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../views/home.dart';
import 'login_or_register.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          }
          else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}