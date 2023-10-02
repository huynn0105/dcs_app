// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';


class HomeState {
  final List<Account> accounts;
  final List<Account> accountsSelected;
  final List<Account> accountsSearched;
  final bool showChecked;
  final bool loading;
  final bool? success;
  final List<AccountResponse> accountsResponse;
  final bool isSave;
  final String? textSearch;
  final String? message;
  final bool isDelete;
  final String? usernameOrEmail;
  final String? domain;

  HomeState({
    this.accounts = const [],
    this.accountsSearched = const [],
    this.accountsSelected = const [],
    this.showChecked = false,
    this.loading = false,
    this.success,
    this.accountsResponse = const [],
    this.textSearch,
    this.message,
    this.isDelete = false,
    this.isSave = false,
    this.usernameOrEmail,
    this.domain,
  });

  HomeState copyWith({
    List<Account>? accounts,
    List<Account>? accountsSelected,
    List<Account>? accountsSearched,
    List<AccountResponse>? accountsResponse,
    bool? showChecked,
    bool? loading,
    bool? success,
    bool? isDelete,
    String? textSearch,
    String? message,
    bool? isSave,
    String? usernameOrEmail,
    String? domain,
  }) {
    return HomeState(
      accounts: accounts ?? this.accounts,
      accountsSelected: accountsSelected ?? this.accountsSelected,
      accountsSearched: accountsSearched ?? this.accountsSearched,
      accountsResponse: accountsResponse ?? this.accountsResponse,
      showChecked: showChecked ?? this.showChecked,
      loading: loading ?? false,
      success: success,
      textSearch: textSearch ?? this.textSearch,
      message: message ?? this.message,
      isDelete: isDelete ?? false,
      isSave: isSave ?? false,
      usernameOrEmail: usernameOrEmail,
      domain: domain,
    );
  }
}
