part of 'login_bloc.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class LoginWithButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginWithButtonPressed({
    required this.password,
    required this.email,
  });
}

class LoginValidateEvent extends LoginEvent {
  final bool? username;
  final bool? password;

  const LoginValidateEvent({
    this.username,
    this.password,
  });
}
