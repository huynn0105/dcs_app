import 'package:dcs_app/data/datasources/dtos/account/account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/account_response/account_response_dto.dart';
import 'package:dcs_app/data/datasources/dtos/auth/auth_dto.dart';
import 'package:dcs_app/data/datasources/dtos/crg_response/crg_response.dart';
import 'package:dcs_app/data/datasources/dtos/login/login_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi(
  baseUrl: 'https://dev.directivecommunications.com/api/v1',
  parser: Parser.MapSerializable,
)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST('/auth/authorize')
  Future<HttpResponse<AuthDto>> login({
    @Body() LoginDto? loginDto,
  });

  @POST('/accounts')
  Future<HttpResponse<void>> createAccount({
    @Body() AccountDto? accountDto,
  });

  @GET('/accounts/client_account_listing')
  Future<HttpResponse<List<AccountResponseDto>>> getListAccounts({
    @Query("token") required String token,
  });

  @GET('/accounts/client_account_listing')
  Future<HttpResponse<List<CRGResponse>>> getListCRGs({
    @Query("token") required String token,
  });

  @GET('/top-headlines')
  Future<HttpResponse<void>> editAccount({
    @Query("id") required int id,
    @Body() AccountDto? accountDto,
  });

  @GET('/top-headlines')
  Future<HttpResponse<void>> deleteAccount({
    @Query("ids") required List<int> ids,
    @Query("token") required String token,
  });
}
