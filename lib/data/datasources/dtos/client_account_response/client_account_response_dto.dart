import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class ClientAccountResponseDto {
  final int id;
  final String accountName;
  final String? username;
  final String nickname;
  final bool isRequest;

  ClientAccountResponseDto({
    required this.id,
    required this.accountName,
    this.username,
    required this.nickname,
    required this.isRequest
  });

  factory ClientAccountResponseDto.fromMap(Map<String, dynamic> map) {
    return ClientAccountResponseDto(
      id: map['id'] as int,
      accountName: map['account_name'] as String,
      nickname: map['nickname'] as String,
      isRequest: map['is_request'] as bool,
      username: map['username'] != null ? map['username'] as String : null,
    );
  }


  @override
  String toString() =>
      'AccountResponseDto(id: $id, accountName: $accountName, username: $username)';
}
