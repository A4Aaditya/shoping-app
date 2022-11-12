import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/app/features/authentication/views/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _globalkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Form(
        key: _globalkey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const SizedBox(height: 25),
            TextFormField(
              controller: _emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => emailValidator(value),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 25),
            TextFormField(
              controller: _passwordController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => passwordValidator(value),
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: loginPressed,
              child: const Text('Login'),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Login with Google'),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have account ?"),
                TextButton(
                  onPressed: signupPressed,
                  child: const Text('SignUp'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void signupPressed() {
    final route = MaterialPageRoute(
      builder: (context) => const SignupScreen(),
    );
    Navigator.push(context, route);
  }

  void loginPressed() {
    if (_globalkey.currentState?.validate() == true) {
      log('login Pressed');
    }
  }

  String? passwordValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'please enter passowrd';
    } else if (value != null && value.length < 6) {
      return 'password should be altleast 6';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Please enter email';
    } else if (value != null && EmailValidator.validate(value) == false) {
      return 'please enter valid email';
    }
    return null;
  }
}
