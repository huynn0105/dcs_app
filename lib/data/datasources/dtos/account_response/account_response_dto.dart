import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class AccountResponseDto {
  final int id;
  @JsonKey(name: 'account_name')
  final String accountName;
  @JsonKey(name: 'user_name')
  final String? username;

  AccountResponseDto({
    required this.id,
    required this.accountName,
    this.username,
  });



  factory AccountResponseDto.fromMap(Map<String, dynamic> map) {
    return AccountResponseDto(
      id: map['id'] as int,
      accountName: map['account_name'] as String,
      username: map['username'] != null ? map['username'] as String : null,
    );
  }

  factory AccountResponseDto.fromJson(String source) => AccountResponseDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AccountResponseDto(id: $id, accountName: $accountName, username: $username)';

}
