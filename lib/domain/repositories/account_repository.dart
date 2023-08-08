import 'package:dcs_app/data/datasources/dtos/account/account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/crg_response/crg_response.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';

import '../../data/datasources/dtos/account_response/account_response_dto.dart';
import '../../data/datasources/dtos/create_account_response/create_account_response.dart';

abstract class AccountRepository {
  Future<DataState<CreateAccountReponse>> createAccount(AccountDto accountDto);
  Future<DataState<void>> editAccount(String id);
  Future<DataState<List<AccountResponseDto>>> getListAccounts(String token);
  Future<DataState<List<CRGResponse>>> getListCRGs(String token);
}
