part of 'select_account_bloc.dart';

sealed class SelectAccountState {}

final class SelectAccountInitial extends SelectAccountState {}

final class SelectAccountFailed extends SelectAccountState {
  final String message;
  SelectAccountFailed({
    required this.message,
  });
}

final class SelectAccountLoading extends SelectAccountState {}

final class SelectAccountLoaded extends SelectAccountState {
  final List<AccountResponse> listAccounts;
  final List<AccountResponse> listAccountsSearched;
  SelectAccountLoaded({
    this.listAccounts = const [],
    this.listAccountsSearched = const [],
  });

  SelectAccountLoaded copyWith({
    List<AccountResponse>? listAccounts,
    List<AccountResponse>? listAccountsSearched,
  }) {
    return SelectAccountLoaded(
      listAccounts: listAccounts ?? this.listAccounts,
      listAccountsSearched: listAccountsSearched ?? this.listAccountsSearched,
    );
  }
}
