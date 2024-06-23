import 'package:firebase_auth/firebase_auth.dart';

class RegisterModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp(String email, String password) async {
    try {
      final trimmedEmail = email.trim();
      await _auth.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );
    } catch (e) {
      throw e;
    }
  }
}

