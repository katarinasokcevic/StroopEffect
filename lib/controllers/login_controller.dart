import 'package:flutter/material.dart';
import 'package:stroop_effect/models/login_model.dart';

class LoginController {
  final LoginModel _model = LoginModel();

  void signUserIn(String email, String password, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await _model.signIn(email, password);

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      showErrorMessage(context, e.toString());
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
    return message.replaceAll(regex, '');
  }


}
