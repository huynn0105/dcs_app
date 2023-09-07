import 'package:dcs_app/data/datasources/dtos/client_account_detail_response/client_account_detail_response_dto.dart';
import 'package:dcs_app/data/datasources/dtos/create_client_account/create_client_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/account_response/account_response.dart';
import 'package:dcs_app/data/datasources/dtos/create_request_account/create_request_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/delete_client_account/delete_client_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/required_account/required_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/update_client_account/update_client_account_dto.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';

import '../../data/datasources/dtos/client_account_response/client_account_response_dto.dart';

abstract class AccountRepository {
  Future<DataState<void>> createRequestAccount(
      CreateRequestAccountDto accountDto);
  Future<DataState<void>> createClientAccount(
      CreateClientAccountDto accountDto);
  Future<DataState<void>> updateClientAccount(
      UpdateClientAccountDto accountDto);
  Future<DataState<List<ClientAccountResponseDto>>> getListClientAccounts(
      String token);
  Future<DataState<List<RequirementAccountDto>>> getRequirementByAccount(
      String token, int id);
  Future<DataState<ClientAccountDetailResponseDto>> getClientAccountDetail(
    String token,
    int id,
    bool isRequestAccount,
  );
  Future<DataState<List<AccountResponse>>> getListAccounts(String token);
  Future<DataState<void>> deleteClientAccounts(
      DeleteClientAccountDto deleteClientAccountDto);
}
