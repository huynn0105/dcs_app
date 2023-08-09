import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dcs_app/domain/models/account.dart';
import 'package:dcs_app/domain/repositories/account_repository.dart';
import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/internet_connection_utils.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AccountRepository _accountRepository = locator<AccountRepository>();
  HomeBloc() : super(HomeState()) {
    on<HomeInitEvent>((event, emit) async {
      if (await InternetConnectionUtils.checkConnection()) {
        emit(state.copyWith(loading: true));
        final accountResponse = await _accountRepository
            .getListAccounts(locator<AuthRepository>().token);
        if (accountResponse is DataSuccess) {
          final accounts =
              accountResponse.data!.map((e) => Account.fromDto(e)).toList();
          emit(state.copyWith(accounts: accounts));
        } else if (accountResponse is DataFailed) {
          emit(
            state.copyWith(
              message: accountResponse.error!.message,
              success: false,
            ),
          );
        }
      } else {
        emit(state.copyWith(
          success: false,
          message: AppText.noInternetMsg,
        ));
      }
    });
    on<AccountSelectedEvent>((event, emit) {
      final accountsSelected = [...state.accountsSelected];
      if (accountsSelected.contains(event.account)) {
        accountsSelected.remove(event.account);
      } else {
        accountsSelected.add(event.account);
      }
      emit(state.copyWith(accountsSelected: accountsSelected));
    });

    on<AccountDeletedEvent>((event, emit) async {
      if (await InternetConnectionUtils.checkConnection()) {
        emit(state.copyWith(loading: true,isDelete: true));
        final accounts = [...state.accounts];
        for (var accountToDelete in state.accountsSelected) {
          accounts.remove(accountToDelete);
        }
        final response = await _accountRepository.deleteAccounts(
            locator<AuthRepository>().token,
            state.accountsSelected.map((e) => e.id).toList());
        if (response is DataSuccess) {
          emit(
            state.copyWith(
              isDelete: true,
              accounts: accounts,
              accountsSelected: [],
              showChecked: false,
            ),
          );
        } else if (response is DataFailed) {
          emit(state.copyWith(
            success: false,
            message: response.error!.message,
          ));
        }
      } else {
        emit(state.copyWith(
          success: false,
          message: AppText.noInternetMsg,
        ));
      }
    });

    on<ClearSelectedAccountsEvent>((event, emit) {
      emit(state.copyWith(accountsSelected: []));
    });

    // on<CreateAccountEvent>((event, emit) async {
    //   emit(state.copyWith(loading: true));
    //   if (await InternetConnectionUtils.checkConnection()) {
    //     final AccountDto account = AccountDto(
    //       url: event.accountName,
    //       username: event.username ?? '',
    //       client: locator<AuthRepository>().email,
    //       token: locator<AuthRepository>().token,
    //     );
    //     final response = await _accountRepository.createAccount(account);

    //     if (response is DataSuccess) {
    //       final account = Account(
    //         id: response.data!.id,
    //         username: event.username ?? '',
    //         email: event.email ?? '',
    //         accountName: event.accountName,
    //       );
    //       emit(
    //         state.copyWith(
    //           success: true,
    //           status: Status.create,
    //           accounts: [account, ...state.accounts],
    //         ),
    //       );
    //     } else if (response is DataFailed) {
    //       emit(state.copyWith(
    //         success: false,
    //         message: response.error!.message,
    //       ));
    //     }
    //   } else {
    //     emit(state.copyWith(
    //       success: false,
    //       message: AppText.noInternetMsg,
    //     ));
    //   }
    // });

    on<ToggleShowCheckEvent>((event, emit) {
      emit(state.copyWith(showChecked: !state.showChecked));
    });

    on<SearchEvent>((event, emit) {
      if (event.textSearch.isEmpty) {
        emit(state.copyWith(
          accountsSearched: [],
          textSearch: '',
        ));
      }
      final textSearch = event.textSearch.toLowerCase();
      final result = state.accounts
          .where((x) =>
              x.username.toLowerCase().contains(textSearch) ||
              x.accountName.toLowerCase().contains(textSearch) ||
              x.email.toLowerCase().contains(textSearch))
          .toList();
      emit(state.copyWith(
        accountsSearched: result,
        textSearch: event.textSearch,
      ));
    });

    on<EditAccountEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      if (await InternetConnectionUtils.checkConnection()) {
        List accounts = [...state.accounts];
        accounts.removeWhere((x) => x.id == event.id);
        final Account account = Account(
          id: 1,
          username: event.accountName,
          email: event.email ?? '',
          accountName: event.accountName,
        );
        emit(
          state.copyWith(
            success: true,
            accounts: [account, ...accounts],
          ),
        );
      } else {
        emit(state.copyWith(
          success: false,
          message: AppText.noInternetMsg,
        ));
      }
    });
    on<AddAccountSyncToAccountsEvent>((event, emit) {});
  }

  Future<List<Account>> syncAccounts() async {
    const channel = MethodChannel('com.example.dcs_app');
    List<Account> accounts = [];
    if (await Permission.contacts.request().isGranted) {
      final result = await channel.invokeMethod('getAllAccounts');
      for (var item in result) {
        final account = Account(
          username: item['account_name'],
          email: item['account_name'],
          id: Random(100).nextInt(1),
          accountName: item['account_type'],
        );
        if (!_isAccountExistent(account, state.accounts)) {
          accounts.add(account);
        }
      }
    }
    return accounts;
  }

  Future<void> pickAccount(
      Future<dynamic> Function(MethodCall call) handleMethodCall) async {
    const channel = MethodChannel('com.example.dcs_app');

    if (await Permission.contacts.request().isGranted) {
      if (await channel.invokeMethod("pickAccount")) {
        channel.setMethodCallHandler(handleMethodCall);
      }
    }
  }

  bool _isAccountExistent(Account account, List<Account> accounts) {
    for (var account in accounts) {
      if (account.accountName == account.accountName &&
          account.email == account.email) {
        return true;
      }
    }
    return false;
  }
}
