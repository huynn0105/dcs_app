part of 'create_account_bloc.dart';

sealed class CreateAccountEvent {}

final class CreateAccountButtonPressedEvent extends CreateAccountEvent {
  final String accountName;
  final String accountNumber;
  final String usernameOrEmail;

  CreateAccountButtonPressedEvent({
    required this.accountName,
    required this.accountNumber,
    required this.usernameOrEmail,
  });
}


final class GetRequirementByAccountEvent extends CreateAccountEvent{
  final int id;
  GetRequirementByAccountEvent({required this.id});
}

final class EditAccountButtonPressedEvent extends CreateAccountEvent {
  final String accountName;
  final String accountNumber;
  final String usernameOrEmail;

  EditAccountButtonPressedEvent({
    required this.accountName,
    required this.accountNumber,
    required this.usernameOrEmail,
  });
}
