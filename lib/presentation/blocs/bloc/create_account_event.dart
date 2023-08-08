part of 'create_account_bloc.dart';

sealed class CreateAccountEvent {}

final class CreateAccountInitEvent extends CreateAccountEvent {}

final class CreateAccountButtonPressedEvent extends CreateAccountEvent {}

final class CreateAccountSearchEvent extends CreateAccountEvent {
  final String searchQuery;

  CreateAccountSearchEvent({
    required this.searchQuery,
  });
}
