import 'package:flutter/material.dart';
import 'package:messenger_app/components/my_button.dart';
import 'package:messenger_app/components/my_text_field.dart';
import 'package:messenger_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign up user
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords don't match!")));
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber.shade200,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  // Create
                  Text("Create an account!",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade800)),

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

                  const SizedBox(height: 10),

                  // confirm password
                  MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm password',
                      obscureText: true),

                  const SizedBox(height: 20),

                  // Sign up button
                  MyButton(onTap: signUp, text: "Sign Up"),

                  const SizedBox(height: 20),

                  // Other opt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
