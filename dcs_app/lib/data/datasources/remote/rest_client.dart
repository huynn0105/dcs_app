
import 'package:dcs_app/data/datasources/dtos/client_account_detail_response/client_account_detail_response_dto.dart';
import 'package:dcs_app/data/datasources/dtos/create_client_account/create_client_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/client_account_response/client_account_response_dto.dart';
import 'package:dcs_app/data/datasources/dtos/auth/auth_dto.dart';
import 'package:dcs_app/data/datasources/dtos/account_response/account_response.dart';
import 'package:dcs_app/data/datasources/dtos/create_request_account/create_request_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/delete_client_account/delete_client_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/login/login_dto.dart';
import 'package:dcs_app/data/datasources/dtos/required_account/required_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/update_client_account/update_client_account_dto.dart';
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
  Future<HttpResponse<void>> createRequestAccount({
    @Body() CreateRequestAccountDto? accountDto,
  });
  @POST('/accounts')
  Future<HttpResponse<void>> createClientAccount({
    @Body() CreateClientAccountDto? accountDto,
  });

  @GET('/accounts/client_account_listing')
  Future<HttpResponse<List<ClientAccountResponseDto>>> getListClientAccounts({
    @Query("token") required String token,
  });

  @GET('/accounts/get_list_accounts')
  Future<HttpResponse<List<AccountResponse>>> getListAccounts({
    @Query("token") required String token,
    @Query("name")  String? name,
    @Query("url")  String? url,
  });

  @GET('/accounts/get_requirement_account')
  Future<HttpResponse<List<RequirementAccountDto>>> getRequirementByAccount({
    @Query("token") required String token,
    @Query("account_id") required int id,
  });


  @GET('/accounts/client_account_detail')
  Future<HttpResponse<ClientAccountDetailResponseDto>> getClientAccountDetail({
    @Query("token") required String token,
    @Query("id") required int id,
    @Query("is_request_account") required bool isRequestAccount,
  });

  @PUT('/accounts/quick_update_client_account')
  Future<HttpResponse<void>> updateAccount({
    @Body() UpdateClientAccountDto? accountDto,
  });

  @DELETE('/accounts/delete_client_account')
  Future<HttpResponse<void>> deleteAccount({
    @Body() DeleteClientAccountDto? deleteClientAccountDto,
  });
}
