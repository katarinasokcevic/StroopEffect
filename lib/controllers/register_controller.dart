import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUserUp(String email, String password, String confirmPassword, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final trimmedEmail = email.trim();

      if (password != confirmPassword) {
        throw Exception("Passwords don't match");
      }

      await _auth.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      final errorMessage = _removeErrorCode(e.toString());
      showErrorMessage(context, errorMessage);
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    final errorMessage = _removeErrorCode(message);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _removeErrorCode(String message) {
    final regex = RegExp(r'\[.*?\]\s*');
    final cleanedMessage = message.replaceAll(regex, '');
    if (cleanedMessage.startsWith('Exception: ')) {
      return cleanedMessage.substring('Exception: '.length);
    }
    return cleanedMessage;
  }
}
