import 'package:bloc/bloc.dart';
import 'package:dcs_app/data/datasources/dtos/account_response/account_response.dart';
import 'package:dcs_app/domain/repositories/account_repository.dart';
import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/internet_connection_utils.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';

part 'select_account_event.dart';
part 'select_account_state.dart';

class SelectAccountBloc extends Bloc<SelectAccountEvent, SelectAccountState> {
  SelectAccountBloc() : super(SelectAccountInitial()) {
    final accountRepository = locator<AccountRepository>();
    on<SelectAccountInitEvent>((event, emit) async {
      if (await InternetConnectionUtils.checkConnection()) {
        emit(SelectAccountLoading());
        final response = await accountRepository
            .getListAccounts(locator<AuthRepository>().token);
        if (response is DataSuccess) {
          emit(SelectAccountLoaded(listAccounts: response.data!));
        } else if (response is DataFailed) {
          emit(SelectAccountFailed(message: response.error!.message!));
        }
      } else {
        emit(
          SelectAccountFailed(
            message: AppText.noInternetMsg,
          ),
        );
      }
    });

    on<SelectAccountSearchEvent>((event, emit) {
      final state = this.state;
      if (state is SelectAccountLoaded) {
        if (event.searchQuery.isEmpty) {
          emit(state.copyWith(listAccountsSearched: []));
          return;
        }
        List<AccountResponse> listAccountsSearched =
            searchAccount(event.searchQuery);
        emit(state.copyWith(listAccountsSearched: listAccountsSearched));
      }
    });
  }

  List<AccountResponse> searchAccount(String searchQuery) {
    if (state is SelectAccountLoaded) {
      final listAccountsSearched = (state as SelectAccountLoaded)
          .listAccounts
          .where(
              (x) => x.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
      return listAccountsSearched;
    } else {
      return [];
    }
  }
}
