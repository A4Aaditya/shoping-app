import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_event.dart';
import 'package:shopping_app/src/app/features/authentication/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<AuthLoginEvent>(_login);
    on<AuthSignupEvent>(_signup);
    on<AuthLogoutEvent>(_logout);
  }

  FutureOr<void> _login(AuthLoginEvent event, Emitter<AuthState> emit) {}

  FutureOr<void> _signup(AuthSignupEvent event, Emitter<AuthState> emit) {}

  FutureOr<void> _logout(AuthLogoutEvent event, Emitter<AuthState> emit) {}
}
