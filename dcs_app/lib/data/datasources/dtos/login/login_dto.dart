import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginDto {
  final String email;
  final String password;
  final String currentBrowser;
  LoginDto({
    required this.email,
    required this.password,
    required this.currentBrowser,
  });

  factory LoginDto.fromMap(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);
  Map<String, dynamic> toMap() => _$LoginDtoToJson(this);
}
