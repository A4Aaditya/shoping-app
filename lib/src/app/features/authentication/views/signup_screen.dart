import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_bloc.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_event.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_state.dart';
import 'package:shopping_app/src/app/features/home/home_screen.dart';

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
  final _confirmPasswordController = TextEditingController();
  final _globalkey = GlobalKey<FormState>();
  bool _isVisible = true;
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
            // first name
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
            // last name
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
            // email
            TextFormField(
              controller: _emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => emailValidator(value),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // password
            TextFormField(
              controller: _passwordController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => passwordValidator(value),
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // confirm password
            TextFormField(
              controller: _confirmPasswordController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => confirmPasswordValidator(value),
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // signup button
            BlocConsumer<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ElevatedButton(
                  onPressed: signupPressed,
                  child: const Text('Signup'),
                );
              },
              listener: (context, state) {
                if (state is AuthSuccessState) {
                  return navigateToHomeScreen();
                } else if (state is AuthErrorState) {
                  return showErrorSnackBar(state.message);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  String? confirmPasswordValidator(String? value) {
    if (value != null &&
        _passwordController.text != _confirmPasswordController.text) {
      return 'password should match';
    } else if (value != null && value.isEmpty) {
      return 'enter confirm password';
    }
    return null;
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

  void toogleObscure() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  String? emailValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Please enter email';
    } else if (value != null && EmailValidator.validate(value) == false) {
      return 'please enter valid email';
    }
    return null;
  }

  void signupPressed() async {
    final email = _emailController.text.trim();
    final password = _confirmPasswordController.text.trim();
    if (_globalkey.currentState?.validate() == true) {
      log('Signup pressed');
      BlocProvider.of<AuthBloc>(context)
          .add(AuthSignupEvent(email: email, password: password));
    }
  }

  void navigateToHomeScreen() {
    final route = MaterialPageRoute(
      builder: (context) => const HomeScreen(),
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  void resetScreen() {
    _firstNameController.text = '';
    _lastNameController.text = '';
    _emailController.text = '';
    _passwordController.text = '';
  }

  void showSuccessSnackBar() {
    const snackBar = SnackBar(
      content: Text('user created'),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
