import 'package:bloc/bloc.dart';
import 'package:dcs_app/data/datasources/dtos/create_client_account/create_client_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/create_request_account/create_request_account_dto.dart';
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

  CreateAccountBloc() : super(CreateAccountState()) {
    on<CreateRequestAccountButtonPressedEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      if (await InternetConnectionUtils.checkConnection()) {
        final CreateRequestAccountDto account = CreateRequestAccountDto(
            url: event.accountName.trim(),
            username: event.usernameOrEmail.trim(),
            client: locator<AuthRepository>().email,
            token: locator<AuthRepository>().token,
            accountNumber: event.accountNumber.trim());
        final response = await accountRepository.createRequestAccount(account);

        if (response is DataSuccess) {
          emit(state.copyWith(success: true));
        } else if (response is DataFailed) {
          emit(
            state.copyWith(
              message: response.errorMessage,
              success: false,
            ),
          );
        }
      } else {
        emit(state.copyWith(
          message: AppText.noInternetMsg,
          success: false,
        ));
      }
    });
    on<CreateClientAccountButtonPressedEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      if (await InternetConnectionUtils.checkConnection()) {
        final CreateClientAccountDto account = CreateClientAccountDto(
          client: locator<AuthRepository>().email,
          token: locator<AuthRepository>().token,
          username: event.username,
          accountId: event.accountId,
          clientRequirements: event.clientRequirements,
        );
        final response = await accountRepository.createClientAccount(account);

        if (response is DataSuccess) {
          emit(state.copyWith(success: true));
        } else if (response is DataFailed) {
          emit(state.copyWith(message: response.errorMessage, success: false));
        }
      } else {
        emit(state.copyWith(
          message: AppText.noInternetMsg,
          success: false,
        ));
      }
    });

    on<GetRequirementByAccountEvent>((event, emit) async {
      if (event.id == null) {
        state.formTextFields = [];
        return;
      }
      emit(state.copyWith(loading: true));
      if (await InternetConnectionUtils.checkConnection()) {
        final response = await accountRepository.getRequirementByAccount(
            locator<AuthRepository>().token, event.id!);
        if (response is DataSuccess) {
          emit(state.copyWith(
            formTextFields: response.data!
                .map((e) => FormTextField(accountDto: e))
                .toList(),
          ));
        } else {
          emit(state.copyWith(
            message: response.errorMessage,
            success: false,
          ));
        }
      } else {
        emit(state.copyWith(
          message: AppText.noInternetMsg,
          success: false,
        ));
      }
    });

    // on<EditAccountButtonPressedEvent>((event, emit) async {
    //   emit(state.copyWith(loading: true));
    //   if (await InternetConnectionUtils.checkConnection()) {
    //     final CreateClientAccountDto account = CreateClientAccountDto(
    //       // url: event.accountName,
    //       username: event.usernameOrEmail,
    //       client: locator<AuthRepository>().email,
    //       token: locator<AuthRepository>().token,
    //     );
    //     final response =
    //         await accountRepository.updateClientAccount(1, account);

    //     if (response is DataSuccess) {
    //       emit(state.copyWith(success: true));
    //     } else if (response is DataFailed) {
    //       emit(state.copyWith(
    //         message: response.error?.message,
    //         success: false,
    //       ));
    //     }
    //   } else {
    //     emit(state.copyWith(
    //       message: AppText.noInternetMsg,
    //       success: false,
    //     ));
    //   }
    // });
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
