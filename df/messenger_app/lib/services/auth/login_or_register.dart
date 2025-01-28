import 'package:flutter/material.dart';
import 'package:messenger_app/pages/login_page.dart';
import 'package:messenger_app/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget
{
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginOrRegister>
{
  // initally show the log screen
  bool showLoginPage = true;

  // toggle between log/reg pages
  void togglePages()
  {
    setState(()
    {
      showLoginPage = !showLoginPage;
    });
  }
  
  @override
  Widget build(BuildContext context)
  {
    if (showLoginPage)
    {
      return LoginPage(onTap: togglePages);
    }
    else
    {
      return RegisterPage(onTap: togglePages);
    }
  }
}