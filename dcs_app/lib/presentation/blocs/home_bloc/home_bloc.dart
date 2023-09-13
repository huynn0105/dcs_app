import 'package:bloc/bloc.dart';
import 'package:dcs_app/data/datasources/dtos/delete_client_account/delete_client_account_dto.dart';
import 'package:dcs_app/domain/models/account.dart';
import 'package:dcs_app/domain/repositories/account_repository.dart';
import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/internet_connection_utils.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';

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
    on<AddAccountSyncToAccountsEvent>((event, emit) {});
  }

  // Future<List<Account>> syncAccounts() async {
  //   const channel = MethodChannel('com.app.DCSPortfolioPlusMobile');
  //   List<Account> accounts = [];
  //   if (await Permission.contacts.request().isGranted) {
  //     final result = await channel.invokeMethod('getAllAccounts');
  //     for (var item in result) {
  //       final account = Account(
  //         username: item['account_name'],
  //         id: Random(100).nextInt(1),
  //         accountName: item['account_type'],
  //         isRequest: true,
  //       );
  //       if (!_isAccountExistent(account, state.accounts)) {
  //         accounts.add(account);
  //       }
  //     }
  //   }
  //   return accounts;
  // }

  // Future<void> pickAccount(
  //     Future<dynamic> Function(MethodCall call) handleMethodCall) async {
  //   const channel = MethodChannel('com.app.DCSPortfolioPlusMobile');

  //   if (await Permission.contacts.request().isGranted) {
  //     if (await channel.invokeMethod("pickAccount")) {
  //       channel.setMethodCallHandler(handleMethodCall);
  //     }
  //   }
  // }

  // bool _isAccountExistent(Account account, List<Account> accounts) {
  //   for (var account1 in accounts) {
  //     if (account1.accountName == account.accountName &&
  //         account1.username == account.username) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }
}
