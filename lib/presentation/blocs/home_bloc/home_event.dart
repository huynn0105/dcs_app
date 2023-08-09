part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeInitEvent extends HomeEvent {}

class AccountSelectedEvent extends HomeEvent {
  final Account account;
  const AccountSelectedEvent({required this.account});
}

class AccountDeletedEvent extends HomeEvent {}

class ClearSelectedAccountsEvent extends HomeEvent {}

// class CreateAccountEvent extends HomeEvent {
//   final String accountName;
//   final String? accountNumber;
//   final String? username;
//   final String? email;

//   const CreateAccountEvent({
//     required this.accountName,
//     this.accountNumber,
//     this.username,
//     this.email,
//   });
// }

class AddAccountSyncToAccountsEvent extends HomeEvent {}

class ToggleShowCheckEvent extends HomeEvent {}

class SearchEvent extends HomeEvent {
  final String textSearch;
  const SearchEvent({
    required this.textSearch,
  });
}

class EditAccountEvent extends HomeEvent {
  final int id;
  final String accountName;
  final String? accountNumber;
  final String? username;
  final String? email;

  EditAccountEvent({
    required this.id,
    required this.accountName,
    this.accountNumber,
    this.username,
    this.email,
  });
}
