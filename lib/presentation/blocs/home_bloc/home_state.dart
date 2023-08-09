// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';


class HomeState {
  final List<Account> accounts;
  final List<Account> accountsSelected;
  final List<Account> accountsSearched;
  final bool showChecked;
  final bool loading;
  final bool? success;
  final List<Account> accountSyncs;
  final String? textSearch;
  final String? message;
  final bool isDelete;

  HomeState({
    this.accounts = const [],
    this.accountsSearched = const [],
    this.accountsSelected = const [],
    this.showChecked = false,
    this.loading = false,
    this.success,
    this.accountSyncs = const [],
    this.textSearch,
    this.message,
    this.isDelete = false,
  });

  HomeState copyWith({
    List<Account>? accounts,
    List<Account>? accountsSelected,
    List<Account>? accountsSearched,
    List<Account>? accountSyncs,
    bool? showChecked,
    bool? loading,
    bool? success,
    bool? isDelete,
    String? textSearch,
    String? message,
  }) {
    return HomeState(
      accounts: accounts ?? this.accounts,
      accountsSelected: accountsSelected ?? this.accountsSelected,
      accountsSearched: accountsSearched ?? this.accountsSearched,
      accountSyncs: accountSyncs ?? this.accountSyncs,
      showChecked: showChecked ?? this.showChecked,
      loading: loading ?? false,
      success: success,
      textSearch: textSearch ?? this.textSearch,
      message: message ?? this.message,
      isDelete: isDelete ?? false,
    );
  }
}
