import 'package:flutter/material.dart';
import '../models/register_model.dart';

class RegisterController {
  final RegisterModel _model = RegisterModel();

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
      if (password != confirmPassword) {
        throw Exception("Passwords don't match");
      }

      await _model.signUp(email, password);

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
