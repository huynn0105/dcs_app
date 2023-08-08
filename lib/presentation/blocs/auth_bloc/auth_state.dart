part of 'auth_bloc.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthNotAuthenticated extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated({
    required this.user,
  });
}

class AuthFailure extends AuthState {
  final String? message;
  const AuthFailure({required this.message});
}

class AuthNoInternetConnection extends AuthState {}
