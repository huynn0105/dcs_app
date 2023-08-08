// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'account_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class AccountDto {
  final String token;
  final String client;
  final String username;
  final String url;
  @JsonKey(name: 'submit_type')
  final String submitType;

  AccountDto({
    required this.token,
    required this.client,
    required this.username,
    required this.url,
    this.submitType = 'save',
  });

  factory AccountDto.fromMap(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);
  Map<String, dynamic> toMap() => _$AccountDtoToJson(this);
}
