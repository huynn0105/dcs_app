import 'package:bloc/bloc.dart';
import 'package:dcs_app/data/datasources/dtos/account/account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/required_account/required_account_dto.dart';
import 'package:dcs_app/domain/repositories/account_repository.dart';
import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/internet_connection_utils.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';
import 'package:flutter/material.dart';

part 'create_account_event.dart';
part 'create_account_state.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  final accountRepository = locator<AccountRepository>();

  CreateAccountBloc() : super(CreateAccountInitial()) {
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

    on<GetRequirementByAccountEvent>((event, emit) async {
      emit(CreateAccountLoading());
      if (await InternetConnectionUtils.checkConnection()) {
        final response = await accountRepository.getRequirementByAccount(
            locator<AuthRepository>().token, event.id);
        if (response is DataSuccess) {
          emit(CreateAccountLoaded(
            formTextFields: response.data!
                .where((e) => e.requirementType == "data")
                .map((e) => FormTextField(accountDto: e))
                .toList(),
          ));
        } else {
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

  Future<List<RequirementAccountDto>> getRequirementByAccount(int id) async {
    final response = await accountRepository.getRequirementByAccount(
        locator<AuthRepository>().token, id);
    if (response is DataSuccess) {
      return response.data!;
    } else {
      return [];
    }
  }
}
