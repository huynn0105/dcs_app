import 'package:dcs_app/data/datasources/dtos/account/account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/crg_response/crg_response.dart';
import 'package:dcs_app/data/datasources/dtos/required_account/required_account_dto.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';

import '../../data/datasources/dtos/account_response/account_response_dto.dart';

abstract class AccountRepository {
  Future<DataState<void>> createAccount(AccountDto accountDto);
  Future<DataState<void>> editAccount(int id, AccountDto accountDto);
  Future<DataState<List<AccountResponseDto>>> getListAccounts(String token);
  Future<DataState<List<RequirementAccountDto>>> getRequirementByAccount(String token, int id);
  Future<DataState<List<CRGResponse>>> getListCRGs(String token);
  Future<DataState<void>> deleteAccounts(String token, List<int> ids);
}
