import 'package:dcs_app/data/datasources/dtos/account/account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/account_response/account_response_dto.dart';
import 'package:dcs_app/data/datasources/dtos/create_account_response/create_account_response.dart';
import 'package:dcs_app/data/datasources/dtos/crg_response/crg_response.dart';
import 'package:dcs_app/data/datasources/remote/rest_client.dart';
import 'package:dcs_app/data/repositories/base/api_base_repository.dart';
import 'package:dcs_app/domain/repositories/account_repository.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';

class AccountRepositoryImpl extends BaseApiRepository
    implements AccountRepository {
  final RestClient _client = locator<RestClient>();

  @override
  Future<DataState<CreateAccountReponse>> createAccount(AccountDto accountDto) {
    return getStateOf(
        request: () => _client.createAccount(accountDto: accountDto));
  }

  @override
  Future<DataState<void>> editAccount(int id, AccountDto accountDto) async {
    return getStateOf(
        request: () => _client.editAccount(id: id, accountDto: accountDto));
  }

  @override
  Future<DataState<List<AccountResponseDto>>> getListAccounts(String token) {
    return getStateOf(request: () => _client.getListAccounts(token: token));
  }

  @override
  Future<DataState<List<CRGResponse>>> getListCRGs(String token) {
    //return getStateOf(request: () => _client.getListCRGs(token: token));
    return Future.value(DataSuccess<List<CRGResponse>>(crgMockData));
  }

  @override
  Future<DataState<void>> deleteAccounts(String token, List<int> ids) {
    //return getStateOf(request: ()=> _client.deleteAccount(ids: ids, token: token));
    return Future.value(const DataSuccess<void>(null));
  }
}
