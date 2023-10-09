
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable(explicitToJson: true)
class AuthDto {
  final String token;
  @JsonKey(name: 'first_name')
  final String firstName;
  final String? defaultSessionName;

  const AuthDto({
    required this.token,
    required this.firstName,
    this.defaultSessionName,
  });


  AuthDto copyWith({
    String? token,
    String? firstName,
    String? defaultSessionName,
  }) {
    return AuthDto(
      token: token ?? this.token,
      firstName: firstName ?? this.firstName,
      defaultSessionName: defaultSessionName ?? this.defaultSessionName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'first_name': firstName,
      'default_session_name': defaultSessionName,
    };
  }

  factory AuthDto.fromMap(Map<String, dynamic> map) {
    return AuthDto(
      token: map['token'] as String,
      firstName: map['first_name'] as String,
      defaultSessionName: map['default_session_name'] != null ? map['default_session_name'] as String : null,
    );
  }
 
}
