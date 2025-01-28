import 'package:flutter/material.dart';
import 'package:messenger_app/components/my_button.dart';
import 'package:messenger_app/components/my_text_field.dart';
import 'package:messenger_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign in
  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  // Welcome
                  const Text("Welcome!",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,)),

                  const SizedBox(height: 10),

                  // email
                  MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false),

                  const SizedBox(height: 10),

                  // password
                  MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true),

                  const SizedBox(height: 20),

                  // Log-in button
                  MyButton(onTap: signIn, text: "Sign-in"),

                  const SizedBox(height: 20),

                  // Other opt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Register",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
