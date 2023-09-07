// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthDto _$AuthDtoFromJson(Map<String, dynamic> json) => AuthDto(
      firstName: json['first_name'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$AuthDtoToJson(AuthDto instance) => <String, dynamic>{
      'token': instance.token,
      'first_name': instance.firstName,
    };
