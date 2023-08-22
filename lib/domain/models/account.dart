import 'package:dcs_app/data/datasources/dtos/client_account_response/client_account_response_dto.dart';

class Account {
  final int id;
  final String username;
  final String accountName;
  final bool isRequest;

  const Account({
    required this.id,
    required this.username,
    required this.accountName,
    required this.isRequest,
  });

  factory Account.fromDto(ClientAccountResponseDto accountDto) {
    return Account(
      id: accountDto.id,
      username: accountDto.nickname,
      accountName: accountDto.accountName,
      isRequest: accountDto.isRequest,
    );
  }
}
