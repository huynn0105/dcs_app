import 'dart:io';

import 'package:autofill_service/autofill_service.dart';
import 'package:bloc/bloc.dart';
import 'package:dcs_app/data/datasources/dtos/account_response/account_response.dart';
import 'package:dcs_app/data/datasources/dtos/delete_client_account/delete_client_account_dto.dart';
import 'package:dcs_app/domain/models/account.dart';
import 'package:dcs_app/domain/repositories/account_repository.dart';
import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/global/router.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/internet_connection_utils.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';
import 'package:get/get.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AccountRepository _accountRepository = locator<AccountRepository>();
  HomeBloc() : super(HomeState()) {
    on<HomeInitEvent>((event, emit) async {
      if (await InternetConnectionUtils.checkConnection()) {
        emit(state.copyWith(loading: true));
        final accountResponse = await _accountRepository
            .getListClientAccounts(locator<AuthRepository>().token);
        if (accountResponse is DataSuccess) {
          final accounts =
              accountResponse.data!.map((e) => Account.fromDto(e)).toList();
          emit(state.copyWith(
            accounts: accounts,
            success: true,
          ));
        } else if (accountResponse is DataFailed) {
          emit(
            state.copyWith(
              message: accountResponse.errorMessage,
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
      emit(state.copyWith(accountsSelected: accountsSelected, success: true));
    });

    on<AccountDeletedEvent>((event, emit) async {
      if (await InternetConnectionUtils.checkConnection()) {
        emit(state.copyWith(loading: true, isDelete: true));
        final accounts = [...state.accounts];
        List<ClientAccountIds> clientIds = [];
        if (event.account != null) {
          clientIds.add(ClientAccountIds(
              id: event.account!.id,
              isRequestAccount: event.account!.isRequest));
          accounts.remove(event.account);
        } else {
          for (var accountToDelete in state.accountsSelected) {
            clientIds.add(ClientAccountIds(
                id: accountToDelete.id,
                isRequestAccount: accountToDelete.isRequest));
            accounts.remove(accountToDelete);
          }
        }

        final response = await _accountRepository.deleteClientAccounts(
          DeleteClientAccountDto(
            token: locator<AuthRepository>().token,
            client: locator<AuthRepository>().email,
            clientAccountIds: clientIds,
          ),
        );
        if (response is DataSuccess) {
          emit(
            state.copyWith(
              isDelete: true,
              accounts: accounts,
              accountsSelected: [],
              showChecked: false,
              success: true,
            ),
          );
        } else if (response is DataFailed) {
          emit(state.copyWith(
            success: false,
            isDelete: true,
            message: response.errorMessage,
            showChecked: event.account == null,
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
      emit(state.copyWith(
        accountsSelected: [],
        success: true,
      ));
    });

    on<ToggleShowCheckEvent>((event, emit) {
      emit(state.copyWith(
        showChecked: !state.showChecked,
        success: true,
      ));
    });

    on<SearchEvent>((event, emit) {
      String searchQuery = event.textSearch.trim();
      if (searchQuery.isEmpty) {
        emit(state.copyWith(
          accountsSearched: [],
          textSearch: '',
          success: true,
        ));
      }
      final textSearch = searchQuery.toLowerCase();
      final result = state.accounts
          .where((x) =>
              x.username.toLowerCase().contains(textSearch) ||
              x.accountName.toLowerCase().contains(textSearch))
          .toList();
      emit(state.copyWith(
        accountsSearched: result,
        textSearch: searchQuery,
        success: true,
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
          accountName: event.accountName,
          isRequest: true,
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
    on<OnSaveAccountEvent>((event, emit) async {
      if (!Platform.isAndroid) return;
      final autofillService = AutofillService();
      final autofillMetadata = await autofillService.autofillMetadata;
      if (autofillMetadata == null) return;
      if (Get.currentRoute != MyRouter.home) {
        Get.until((route) => route.isFirst);
      }
      emit(state.copyWith(loading: true, isSave: true));
      String? url = autofillMetadata.webDomains.firstOrNull?.domain;
      String? name;
      if (autofillMetadata.packageNames.firstOrNull != null) {
        String packageName = autofillMetadata.packageNames.firstOrNull!;
        name = packageName
            .replaceAll("com.", "")
            .replaceAll("android.", "")
            .replaceAll("apps.", "")
            .replaceAll("app.", "")
            .replaceAll("package.", "")
            .replaceAll("example.", "")
            .replaceAll("org.", "")
            .replaceAll("mobile.", "");
      }
      if (url?.isNotEmpty == true || name?.isNotEmpty == true) {
        final response = await locator<AccountRepository>().getListAccounts(
            token: locator<AuthRepository>().token, url: url, name: name);
        emit(state.copyWith(loading: false, isSave: true));
        if (response is DataSuccess) {
          final data = response.data!;
          emit(state.copyWith(
            success: true,
            accountsResponse: data,
            isSave: true,
            usernameOrEmail: autofillMetadata.saveInfo?.username,
            domain: url ?? name,
          ));
        } else {
          emit(state.copyWith(
            success: false,
            message: response.errorMessage,
          ));
        }
      } else {
        emit(state.copyWith(
          success: true,
          accountsResponse: [],
          isSave: true,
          usernameOrEmail: autofillMetadata.saveInfo?.username,
        ));
      }
    });
  }
}
