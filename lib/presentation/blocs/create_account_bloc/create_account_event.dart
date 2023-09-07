part of 'create_account_bloc.dart';

sealed class CreateAccountEvent {}

final class CreateRequestAccountButtonPressedEvent extends CreateAccountEvent {
  final String accountName;
  final String accountNumber;
  final String usernameOrEmail;

  CreateRequestAccountButtonPressedEvent({
    required this.accountName,
    required this.accountNumber,
    required this.usernameOrEmail,
  });
}

final class CreateClientAccountButtonPressedEvent extends CreateAccountEvent {
  final int accountId;
  final String username;
  final String email;
  final List<ClientRequirementDtos> clientRequirements;

  CreateClientAccountButtonPressedEvent({
    required this.accountId,
    required this.username,
    required this.clientRequirements,
    required this.email,
  });
}

final class GetRequirementByAccountEvent extends CreateAccountEvent {
  final int? id;
  GetRequirementByAccountEvent({this.id});
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
