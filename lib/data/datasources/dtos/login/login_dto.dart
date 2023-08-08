import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginDto {
  final String email;
  final String password;
  LoginDto({
    required this.email,
    required this.password,
  });

  factory LoginDto.fromMap(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);
  Map<String, dynamic> toMap() => _$LoginDtoToJson(this);
}
