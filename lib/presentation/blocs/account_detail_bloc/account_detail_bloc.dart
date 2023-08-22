import 'package:bloc/bloc.dart';
import 'package:dcs_app/data/datasources/dtos/client_account_detail_response/client_account_detail_response_dto.dart';
import 'package:dcs_app/data/datasources/dtos/update_client_account/update_client_account_dto.dart';
import 'package:dcs_app/domain/models/account.dart';
import 'package:dcs_app/domain/repositories/account_repository.dart';
import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';
import 'package:flutter/material.dart';

part 'account_detail_event.dart';
part 'account_detail_state.dart';

class AccountDetailBloc extends Bloc<AccountDetailEvent, AccountDetailState> {
  final _accountRepository = locator<AccountRepository>();
  AccountDetailBloc() : super(const AccountDetailState()) {
    on<AccountDetailInitEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      final response = await _accountRepository.getClientAccountDetail(
        locator<AuthRepository>().token,
        event.account.id,
        event.account.isRequest,
      );
      if (response is DataSuccess) {
        List<FormTextField> formTextFields = [];
        if (response.data!.requirementAccount != null) {
          formTextFields = response.data!.requirementAccount!
              .map(
                (e) => FormTextField(
                  accountRequirement: e,
                  initValue: e.value ?? '',
                ),
              )
              .toList();
        }
        emit(state.copyWith(
          accountDetail: response.data!,
          formTextFields: formTextFields,
        ));
      } else if (response is DataFailed) {
        emit(state.copyWith(
          message: response.error!.message,
          success: false,
        ));
      }
    });

    on<AccountDetailUpdateEvent>((event, emit) async {
      emit(state.copyWith(loading: true));

      final String token = locator<AuthRepository>().token;
      final String client = locator<AuthRepository>().email;

      final response =
          await _accountRepository.updateClientAccount(UpdateClientAccountDto(
        token: token,
        client: client,
        isRequestAccount: false,
        clientAccount: event.clientAccount,
      ));

      if (response is DataSuccess) {
        emit(state.copyWith(
          success: true,
        ));
      } else if (response is DataFailed) {
        emit(state.copyWith(
          success: false,
          message: response.error?.message,
        ));
      }
    });

    on<RequestAccountDetailUpdateEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      final String token = locator<AuthRepository>().token;
      final String client = locator<AuthRepository>().email;

      final response =
          await _accountRepository.updateClientAccount(UpdateClientAccountDto(
        token: token,
        client: client,
        isRequestAccount: true,
        clientRequestAccount: UpdateClientRequestAccount(
          id: event.id,
          accountNumber: event.accountNumber,
          username: event.username,
          nickname: event.nickname,
        ),
      ));

      if (response is DataSuccess) {
        emit(state.copyWith(
          success: true,
        ));
      } else if (response is DataFailed) {
        emit(state.copyWith(
          success: false,
          message: response.error?.message,
        ));
      }
    });
  }
}
