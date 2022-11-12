import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _globalkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp Screen'),
      ),
      body: Form(
        key: _globalkey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            TextFormField(
              controller: _firstNameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => firstNameValidator(value),
              decoration: InputDecoration(
                hintText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 25),
            TextFormField(
              controller: _lastNameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => lastNameValidator(value),
              decoration: InputDecoration(
                hintText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
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
              onPressed: signupPressed,
              child: const Text('Signup'),
            )
          ],
        ),
      ),
    );
  }

  String? firstNameValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'please enter first name';
    } else if (value != null && value.length < 3) {
      return 'first name should be of atleast 3';
    }
    return null;
  }

  String? lastNameValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'please enter first name';
    } else if (value != null && value.length < 3) {
      return 'first name should be of atleast 3';
    }
    return null;
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

  void signupPressed() {
    if (_globalkey.currentState?.validate() == true) {
      log('Signup pressed');
    }
  }
}
