part of 'create_account_bloc.dart';

sealed class CreateAccountState {}

final class CreateAccountInitial extends CreateAccountState {}


final class CreateAccountSucceeded extends CreateAccountState {}

final class CreateAccountFailed extends CreateAccountState {
  final String message;
  CreateAccountFailed({
    required this.message,
  });
}

final class CreateAccountLoading extends CreateAccountState {}
