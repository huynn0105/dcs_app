import 'package:dcs_app/data/datasources/dtos/auth/auth_dto.dart';
import 'package:dcs_app/data/datasources/dtos/login/login_dto.dart';
import 'package:dcs_app/data/datasources/local/database_constants.dart';
import 'package:dcs_app/data/datasources/local/database_manager.dart';
import 'package:dcs_app/data/repositories/base/api_base_repository.dart';
import 'package:dcs_app/domain/models/user/user.dart';
import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../datasources/remote/rest_client.dart';

class AuthRepositoryImpl extends BaseApiRepository implements AuthRepository {
  final RestClient _client = locator<RestClient>();

  @override
  Future<DataState<AuthDto>> login(String email, String password) async {
    final deviceInfoPlugin = await DeviceInfoPlugin().deviceInfo;
    final deviceInfo = deviceInfoPlugin.data;
    return getStateOf(request: () {
      return _client.login(
        loginDto: LoginDto(
          email: email,
          password: password,
          currentBrowser: deviceInfo['name'] ?? '',
        ),
      );
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
    try {
      final user = DatabaseManager.readData(DatabaseConstant.user);
      final email = DatabaseManager.readData(DatabaseConstant.email);
      final token = DatabaseManager.readData(DatabaseConstant.token);
      final browsers = List<String>.from(
          DatabaseManager.readJsonData(DatabaseConstant.browsers));
      final defaultSessionName =
          DatabaseManager.readData(DatabaseConstant.defaultSessionName);
      if (user == null || email == null || token == null) return null;
      return User(
          username: user,
          email: email,
          token: token,
          defaultSessionName: defaultSessionName,
          browsers: browsers);
    } catch (e) {
      return null;
    }
  }

  @override
  void clearData() {
    DatabaseManager.deleteData(DatabaseConstant.user);
    DatabaseManager.deleteData(DatabaseConstant.token);
    DatabaseManager.deleteData(DatabaseConstant.email);
    DatabaseManager.deleteData(DatabaseConstant.defaultSessionName);
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
    String? defaultSessionName,
    required List<String> browsers,
  }) async {
    await DatabaseManager.saveData(DatabaseConstant.user, username);
    await DatabaseManager.saveData(DatabaseConstant.token, token);
    await DatabaseManager.saveData(DatabaseConstant.email, email);
    await DatabaseManager.saveData(
        DatabaseConstant.defaultSessionName, defaultSessionName);
    await DatabaseManager.saveJsonData(DatabaseConstant.browsers, browsers);
  }
}
