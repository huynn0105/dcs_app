import 'package:dcs_app/data/datasources/dtos/create_client_account/create_client_account_dto.dart';

class UpdateClientAccountDto {
  final String token;
  final String client;
  final bool isRequestAccount;
  final UpdateClientRequestAccount? clientRequestAccount;
  final UpdateClientAccount? clientAccount;

  const UpdateClientAccountDto({
    required this.token,
    required this.client,
    required this.isRequestAccount,
    this.clientRequestAccount,
    this.clientAccount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'client': client,
      'is_request_account': isRequestAccount,
      'client_request_account': clientRequestAccount?.toMap(),
      'client_account': clientAccount?.toMap(),
    };
  }
}

class UpdateClientRequestAccount {
  final int id;
  final String? username;
  final String? accountNumber;
  final String? nickname;
  const UpdateClientRequestAccount({
    required this.id,
    this.username,
    this.accountNumber,
    this.nickname,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'account_number': accountNumber,
      'nickname': nickname,
    };
  }
}

class UpdateClientAccount {
  final int id;
  final List<ClientRequirementDtos> clientRequirements;
  final String? nickname;
  const UpdateClientAccount({
    required this.id,
    required this.clientRequirements,
    this.nickname,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nickname': nickname,
      'client_requirements': clientRequirements.map((x) => x.toMap()).toList(),
    };
  }
}
