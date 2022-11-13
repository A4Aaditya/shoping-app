import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final _instance = FirebaseAuth.instance;
  final provider = GoogleAuthProvider();
  Future<User?> login({required String email, required String password}) async {
    try {
      final auth = await _instance.signInWithEmailAndPassword(
          email: email, password: password);
      return auth.user;
    } catch (message) {
      log(message.toString());
      rethrow;
    }
  }

  Future<User?> signup(
      {required String email, required String password}) async {
    try {
      final auth = await _instance.createUserWithEmailAndPassword(
          email: email, password: password);
      return auth.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Something went wrong';
    } catch (message) {
      log(message.toString());
      rethrow;
    }
  }

  Future<User?> loginWithGoogle() async {
    try {
      final auth = await _instance.signInWithProvider(provider);
      return auth.user;
    } catch (message) {
      log(message.toString());
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await _instance.signOut();
    } catch (message) {
      log(message.toString());
      rethrow;
    }
  }
}
