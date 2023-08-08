// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountDto _$AccountDtoFromJson(Map<String, dynamic> json) => AccountDto(
      token: json['token'] as String,
      client: json['client'] as String,
      username: json['username'] as String,
      url: json['url'] as String,
      submitType: json['submit_type'] as String? ?? 'save',
    );

Map<String, dynamic> _$AccountDtoToJson(AccountDto instance) =>
    <String, dynamic>{
      'token': instance.token,
      'client': instance.client,
      'username': instance.username,
      'url': instance.url,
      'submit_type': instance.submitType,
    };
