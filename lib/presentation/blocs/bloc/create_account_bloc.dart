import 'package:bloc/bloc.dart';
import 'package:dcs_app/data/datasources/dtos/crg_response/crg_response.dart';
import 'package:dcs_app/domain/repositories/account_repository.dart';
import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/internet_connection_utils.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';

part 'create_account_event.dart';
part 'create_account_state.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc() : super(CreateAccountInitial()) {
    final accountRepository = locator<AccountRepository>();
    on<CreateAccountInitEvent>((event, emit) async {
      if (await InternetConnectionUtils.checkConnection()) {
        emit(CreateAccountLoading());
        final response = await accountRepository
            .getListCRGs(locator<AuthRepository>().token);
        if (response is DataSuccess) {
          emit(CreateAccountLoaded(listCRGs: response.data!));
        } else if (response is DataFailed) {
          emit(CreateAccountFailed(message: response.error!.message!));
        }
      } else {
        emit(
          CreateAccountFailed(
            message: AppText.noInternetMsg,
          ),
        );
      }
    });

    on<CreateAccountSearchEvent>((event, emit) {
      final state = this.state;
      if (state is CreateAccountLoaded) {
        if (event.searchQuery.isEmpty) {
          emit(state.copyWith(listCRGsSearched: []));
          return;
        }
        List<CRGResponse> listCRGsSearched = searchCRG(event.searchQuery);
        emit(state.copyWith(listCRGsSearched: listCRGsSearched));
      }
    });
  }

  List<CRGResponse> searchCRG(String searchQuery) {
    if (state is CreateAccountLoaded) {
      final listCRGsSearched = (state as CreateAccountLoaded)
          .listCRGs
          .where(
              (x) => x.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
      return listCRGsSearched;
    } else {
      return [];
    }
  }
}
