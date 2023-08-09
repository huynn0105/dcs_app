import 'package:bloc/bloc.dart';
import 'package:dcs_app/data/datasources/dtos/account/account_dto.dart';
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

    on<CreateAccountButtonPressedEvent>((event, emit) async {
      emit(CreateAccountLoading());
      if (await InternetConnectionUtils.checkConnection()) {
        final AccountDto account = AccountDto(
          url: event.accountName,
          username: event.usernameOrEmail,
          client: locator<AuthRepository>().email,
          token: locator<AuthRepository>().token,
        );
        final response = await accountRepository.createAccount(account);

        if (response is DataSuccess) {
          emit(CreateAccountSucceeded());
        } else if (response is DataFailed) {
          emit(CreateAccountFailed(message: response.error!.message!));
        }
      } else {
        emit(CreateAccountFailed(
          message: AppText.noInternetMsg,
        ));
      }
    });

    on<EditAccountButtonPressedEvent>((event, emit) async {
      emit(CreateAccountLoading());
      if (await InternetConnectionUtils.checkConnection()) {
        final AccountDto account = AccountDto(
          url: event.accountName,
          username: event.usernameOrEmail,
          client: locator<AuthRepository>().email,
          token: locator<AuthRepository>().token,
        );
        final response = await accountRepository.editAccount(1, account);

        if (response is DataSuccess) {
          emit(CreateAccountSucceeded());
        } else if (response is DataFailed) {
          emit(CreateAccountFailed(message: response.error!.message!));
        }
      } else {
        emit(CreateAccountFailed(
          message: AppText.noInternetMsg,
        ));
      }
    });
  }
}
