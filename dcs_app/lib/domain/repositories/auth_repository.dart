import 'package:dcs_app/data/datasources/dtos/auth/auth_dto.dart';
import 'package:dcs_app/domain/models/user/user.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';

abstract class AuthRepository {
  Future<DataState<AuthDto>> login(String email, String password);
  Future<bool?> getAccountByToken(String token);
  User? get getUser;
  Future<void> saveUserToken({
    required String username,
    required String token,
    required String email,
    String? defaultSessionName,
    required List<String> browsers,
  });
  void clearData();
  String get token;
  String get email;
}
