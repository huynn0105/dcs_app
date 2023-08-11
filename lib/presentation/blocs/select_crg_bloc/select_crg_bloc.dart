import 'package:bloc/bloc.dart';
import 'package:dcs_app/data/datasources/dtos/crg_response/crg_response.dart';
import 'package:dcs_app/domain/repositories/account_repository.dart';
import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/internet_connection_utils.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';

part 'select_crg_event.dart';
part 'select_crg_state.dart';

class SelectCRGBloc extends Bloc<SelectCRGEvent, SelectCRGState> {
  SelectCRGBloc() : super(SelectCRGInitial()) {
    final accountRepository = locator<AccountRepository>();
    on<SelectCRGInitEvent>((event, emit) async {
      if (await InternetConnectionUtils.checkConnection()) {
        emit(SelectCRGLoading());
        final response = await accountRepository
            .getListCRGs(locator<AuthRepository>().token);
        if (response is DataSuccess) {
          emit(SelectCRGLoaded(listCRGs: response.data!));
        } else if (response is DataFailed) {
          emit(SelectCRGFailed(message: response.error!.message!));
        }
      } else {
        emit(
          SelectCRGFailed(
            message: AppText.noInternetMsg,
          ),
        );
      }
    });

    on<SelectCRGSearchEvent>((event, emit) {
      final state = this.state;
      if (state is SelectCRGLoaded) {
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
    if (state is SelectCRGLoaded) {
      final listCRGsSearched = (state as SelectCRGLoaded)
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
