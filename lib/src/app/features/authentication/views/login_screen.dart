import 'dart:developer';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_bloc.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_event.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_state.dart';
import 'package:shopping_app/src/app/features/authentication/views/signup_screen.dart';
import 'package:shopping_app/src/app/features/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _globalkey = GlobalKey<FormState>();
  bool _isVisible = true;
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
              obscureText: _isVisible,
              validator: (value) => passwordValidator(value),
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: toggleObscure,
                  icon: _isVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 25),

            BlocConsumer<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    // login
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: loginPressed,
                        child: const Text('Login'),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password'),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // google login
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: loginWithGooglePressed,
                        child: const Text('Login with Google'),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // signup
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
                );
              },
              listener: (context, state) {
                if (state is AuthErrorState) {
                  return showSnackBar(state.message);
                } else if (state is AuthSuccessState) {
                  return navigateToHomeScreen();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void loginWithGooglePressed() async {
    BlocProvider.of<AuthBloc>(context).add(GoogleLoginEvent());
  }

  void toggleObscure() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void signupPressed() {
    final route = MaterialPageRoute(
      builder: (context) => const SignupScreen(),
    );
    Navigator.push(context, route);
  }

  void loginPressed() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (_globalkey.currentState?.validate() == true) {
      log('login Pressed');
      BlocProvider.of<AuthBloc>(context)
          .add(AuthLoginEvent(email: email, password: password));
    }
  }

  void navigateToHomeScreen() {
    final route = MaterialPageRoute(
      builder: (context) => const HomeScreen(),
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
