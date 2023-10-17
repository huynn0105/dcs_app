import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class AuthDto {
  final String token;
  @JsonKey(name: 'first_name')
  final String firstName;
  final String? defaultSessionName;
  final List<String> browsers;

  const AuthDto({
    required this.token,
    required this.firstName,
    this.defaultSessionName,
    this.browsers = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'firstName': firstName,
      'defaultSessionName': defaultSessionName,
      'browsers': browsers,
    };
  }

  factory AuthDto.fromMap(Map<String, dynamic> map) {
    return AuthDto(
      token: map['token'] as String,
      firstName: map['first_name'] as String,
      defaultSessionName: map['default_session_name'] != null
          ? map['default_session_name'] as String
          : null,
      browsers: List<String>.from((map['browsers'] as List)),
    );
  }
}
