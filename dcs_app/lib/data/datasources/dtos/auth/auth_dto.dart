import 'package:json_annotation/json_annotation.dart';

part 'auth_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthDto {
  final String token;
  @JsonKey(name: 'first_name')
  final String firstName;

  const AuthDto({
    required this.firstName,
    required this.token,
  });

  factory AuthDto.fromMap(Map<String, dynamic> json) =>
      _$AuthDtoFromJson(json);
  Map<String, dynamic> toMap() => _$AuthDtoToJson(this);
}
