part of 'login_bloc.dart';

class LoginState {
  final bool validateUsername;
  final bool validatePassword;
  final bool? success;
  final bool loading;
  final String? message;
  final String? token;

  const LoginState({
    this.validateUsername = false,
    this.validatePassword = false,
    this.success,
    this.loading = false,
    this.message,
    this.token,
  });

  bool get validate => validateUsername && validatePassword;

  LoginState copyWith({
    bool? validateUsername,
    bool? validatePassword,
    bool? success,
    bool? loading,
    String? message,
    String? token,
    bool? isFirstChangePassword,
  }) {
    return LoginState(
      validateUsername: validateUsername ?? this.validateUsername,
      validatePassword: validatePassword ?? this.validatePassword,
      success: success,
      loading: loading ?? false,
      message: message,
      token: token,
    );
  }
}