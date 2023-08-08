import 'package:dcs_app/data/datasources/dtos/account_response/account_response_dto.dart';

class Account {
  final int id;
  final String username;
  final String accountName;
  final String email;

  const Account({
    required this.id,
    required this.username,
    required this.email,
    required this.accountName,
  });

  factory Account.fromDto(AccountResponseDto accountDto) {
    return Account(
      id: accountDto.id,
      username: accountDto.username ?? '',
      email: accountDto.username ?? '',
      accountName: accountDto.accountName,
    );
  }
}
