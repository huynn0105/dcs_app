import 'package:dcs_app/data/repositories/auth_repository_impl.dart';
import 'package:dcs_app/data/repositories/account_repository_impl.dart';
import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/domain/repositories/account_repository.dart';
import 'package:dcs_app/global/environment.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/datasources/remote/rest_client.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async {
  final dio = Dio();

  locator.registerSingleton<Dio>(dio);

  locator.registerLazySingleton<RestClient>(
    () => RestClient(locator<Dio>(), baseUrl: EnvironmentConfig.apiURL),
  );
  setupRepositoryService();
}

void setupRepositoryService() {
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );
  locator.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(),
  );
}
