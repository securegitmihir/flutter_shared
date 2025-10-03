import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial(isLoggedIn: false)) {
    on<IsLoggedIn>(_isLoggedIn);
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) => AuthState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(AuthState state) => state.toJson();

  FutureOr<void> _isLoggedIn(IsLoggedIn event, Emitter<AuthState> emit) {
    emit(state.copyWith(isLoggedIn: event.isNewUser));
  }
}
