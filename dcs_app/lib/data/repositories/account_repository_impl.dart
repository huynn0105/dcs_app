import 'package:dcs_app/data/datasources/dtos/client_account_detail_response/client_account_detail_response_dto.dart';
import 'package:dcs_app/data/datasources/dtos/create_client_account/create_client_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/client_account_response/client_account_response_dto.dart';
import 'package:dcs_app/data/datasources/dtos/account_response/account_response.dart';
import 'package:dcs_app/data/datasources/dtos/create_request_account/create_request_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/delete_client_account/delete_client_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/required_account/required_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/update_client_account/update_client_account_dto.dart';
import 'package:dcs_app/data/datasources/remote/rest_client.dart';
import 'package:dcs_app/data/repositories/base/api_base_repository.dart';
import 'package:dcs_app/domain/repositories/account_repository.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';

class AccountRepositoryImpl extends BaseApiRepository
    implements AccountRepository {
  final RestClient _client = locator<RestClient>();

  @override
  Future<DataState<void>> createRequestAccount(
      CreateRequestAccountDto accountDto) {
    return getStateOf(
        request: () => _client.createRequestAccount(accountDto: accountDto));
  }

  @override
  Future<DataState<void>> updateClientAccount(
      UpdateClientAccountDto accountDto) async {
    return getStateOf(
        request: () => _client.updateAccount(accountDto: accountDto));
  }

  @override
  Future<DataState<List<ClientAccountResponseDto>>> getListClientAccounts(
      String token) {
    return getStateOf(
        request: () => _client.getListClientAccounts(token: token));
  }

  @override
  Future<DataState<List<AccountResponse>>> getListAccounts(String token) {
    return getStateOf(request: () => _client.getListAccounts(token: token));
  }

  @override
  Future<DataState<void>> deleteClientAccounts(
      DeleteClientAccountDto deleteClientAccountDto) {
    return getStateOf(
        request: () => _client.deleteAccount(
            deleteClientAccountDto: deleteClientAccountDto));
  }

  @override
  Future<DataState<List<RequirementAccountDto>>> getRequirementByAccount(
      String token, int id) {
    return getStateOf(
        request: () => _client.getRequirementByAccount(token: token, id: id));
  }
  @override
  Future<DataState<AccountResponse>> getAccountByDomain(
      String token, String domain) {
    return getStateOf(
        request: () => _client.getAccountByDomain(token: token, domain: domain));
  }

  @override
  Future<DataState<ClientAccountDetailResponseDto>> getClientAccountDetail(
      String token, int id, bool isRequestAccount) {
    return getStateOf(
        request: () => _client.getClientAccountDetail(
            token: token, id: id, isRequestAccount: isRequestAccount));
  }

  @override
  Future<DataState<void>> createClientAccount(
      CreateClientAccountDto accountDto) {
    return getStateOf(
        request: () => _client.createClientAccount(accountDto: accountDto));
  }
}
