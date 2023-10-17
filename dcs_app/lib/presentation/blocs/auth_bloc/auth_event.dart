part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AppLoaded extends AuthEvent {}

class GetUserByTokenEvent extends AuthEvent {
  final String token;
  const GetUserByTokenEvent({required this.token});
}

class UserLoggedOut extends AuthEvent {}

class UserTokenExpired extends AuthEvent {
  const UserTokenExpired();
}
