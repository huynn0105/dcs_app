import 'package:dcs_app/data/datasources/dtos/auth/auth_dto.dart';
import 'package:dcs_app/data/datasources/dtos/login/login_dto.dart';
import 'package:dcs_app/data/datasources/local/database_constants.dart';
import 'package:dcs_app/data/datasources/local/database_manager.dart';
import 'package:dcs_app/data/repositories/base/api_base_repository.dart';
import 'package:dcs_app/domain/models/user/user.dart';
import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';

import '../datasources/remote/rest_client.dart';

class AuthRepositoryImpl extends BaseApiRepository implements AuthRepository {
  final RestClient _client = locator<RestClient>();

  @override
  Future<DataState<AuthDto>> login(String email, String password) async {
    return getStateOf(request: () {
      return _client.login(
          loginDto: LoginDto(email: email, password: password));
    });
  }

  @override
  Future<bool?> getAccountByToken(String token) async {
    final accountJson = DatabaseManager.readJsonData(DatabaseConstant.user);
    if (accountJson == null) return false;
    return true;
  }

  @override
  User? get getUser {
    final user = DatabaseManager.readData(DatabaseConstant.user);
    if (user == null) return null;
    return User(username: user);
  }

  @override
  Future<void> clearData() async {
    await DatabaseManager.deleteData(DatabaseConstant.user);
    await DatabaseManager.deleteData(DatabaseConstant.token);
    await DatabaseManager.deleteData(DatabaseConstant.email);
  }

  @override
  String get token => DatabaseManager.readData(DatabaseConstant.token);

  @override
  String get email => DatabaseManager.readData(DatabaseConstant.email);

  @override
  Future<void> saveUserToken({
    required String username,
    required String token,
    required String email,
  }) async {
    await DatabaseManager.saveData(DatabaseConstant.user, username);
    await DatabaseManager.saveData(DatabaseConstant.token, token);
    await DatabaseManager.saveData(DatabaseConstant.email, email);
  }
}
