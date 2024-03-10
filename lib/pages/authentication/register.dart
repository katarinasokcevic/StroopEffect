import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../base_scaffold.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onTap});

  final Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "The Stroop Effect",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Welcome to Stroop Effect app!',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              _buildTextField(emailController, 'Email', obscureText: false),
              const SizedBox(height: 10),
              _buildTextField(passwordController, 'Password',
                  obscureText: true),
              const SizedBox(height: 10),
              _buildTextField(confirmPasswordController, 'Confirm Password',
                  obscureText: true),
              const SizedBox(height: 25),
              _buildSignUpButton(),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (passwordController.text != confirmPasswordController.text) {
        if (context.mounted) {
          Navigator.pop(context);
          showErrorMessage("Passwords don't match");
        }
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = "Invalid email";
          break;
        case 'weak-password':
          message = "Weak password";
          break;
        default:
          message = e.message ?? "An error occurred";
      }

      if (context.mounted) {
        Navigator.pop(context);
        showErrorMessage(message);
      }
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResponsiveContainer(double maxWidth, Widget child) {
    double width = maxWidth;
    if (MediaQuery.of(context).size.shortestSide < 600) {
      width *= 0.8;
    } else if (MediaQuery.of(context).size.shortestSide >= 600 &&
        MediaQuery.of(context).size.shortestSide < 1200) {
      width *= 0.4;
    } else {
      width *= 0.15;
    }
    return Center(
      child: Container(
        width: width,
        child: child,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _buildResponsiveContainer(
          constraints.maxWidth,
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpButton() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _buildResponsiveContainer(
          constraints.maxWidth,
          GestureDetector(
            onTap: signUserUp,
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
