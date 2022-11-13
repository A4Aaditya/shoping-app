import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_event.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_state.dart';
import 'package:shopping_app/src/app/features/authentication/repository/user_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<AuthLoginEvent>(_login);
    on<AuthSignupEvent>(_signup);
    on<AuthLogoutEvent>(_logout);
  }

  FutureOr<void> _login(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final user = await UserRepository()
          .login(email: event.email, password: event.password);

      if (user != null) {
        emit(AuthSuccessState());
      } else {
        (emit(
          AuthErrorState(
              message:
                  'The password is invalid or the user does not have a password'),
        ));
      }
    } catch (message) {
      emit(AuthErrorState(message: message.toString()));
    }
  }

  FutureOr<void> _signup(AuthSignupEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      final user = await UserRepository()
          .signup(email: event.email, password: event.password);

      if (user != null) {
        emit(AuthSuccessState());
      } else {
        const message =
            ' The email address is already in use by another account';
        final value = AuthErrorState(message: message);
        emit(value);
      }
    } catch (message) {
      emit(AuthErrorState(message: message.toString()));
    }
  }

  FutureOr<void> _logout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await UserRepository().logout();
      emit(AuthInitialState());
    } catch (message) {
      log(message.toString());
      emit(AuthErrorState(message: message.toString()));
    }
  }
}
