import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_bloc.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_event.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_state.dart';
import 'package:shopping_app/src/app/features/authentication/views/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            return navigateToLoginScreen();
          }
        },
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () async {
                BlocProvider.of<AuthBloc>(context).add(AuthLogoutEvent());
              },
              child: const Text('SignOut'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToLoginScreen() {
    final route = MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }
}
