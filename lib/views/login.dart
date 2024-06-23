import 'package:flutter/material.dart';
import 'package:stroop_effect/controllers/login_controller.dart';
import 'base_scaffold.dart';

class LoginPage extends StatelessWidget {
  final Function()? onTap;
  final LoginController _controller = LoginController();

  LoginPage({Key? key, required this.onTap}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                'Welcome back!',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              _buildTextField(
                context: context,
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                context: context,
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 35),
              _buildSignInButton(context),
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
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      'Register now',
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

  Widget _buildResponsiveContainer(BuildContext context, double maxWidth,
      Widget child) {
    double width = maxWidth;
    if (MediaQuery
        .of(context)
        .size
        .shortestSide < 600) {
      width *= 0.8;
    } else if (MediaQuery
        .of(context)
        .size
        .shortestSide >= 600 &&
        MediaQuery
            .of(context)
            .size
            .shortestSide < 1200) {
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

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return _buildResponsiveContainer(
      context,
      MediaQuery
          .of(context)
          .size
          .width,
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
  }


  Widget _buildSignInButton(BuildContext context) {
    return _buildResponsiveContainer(
      context,
      MediaQuery.of(context).size.width,
      GestureDetector(
        onTap: () {
          _controller.signUserIn(
            emailController.text,
            passwordController.text,
            context,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.pink,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              "Sign In",
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
  }

}
