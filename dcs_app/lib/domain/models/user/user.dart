import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String username;
  final String token;
  final String email;
  final String? defaultSessionName;

  const User({
    required this.username,
    required this.token,
    required this.email,
    this.defaultSessionName,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'token': token,
      'email': email,
      'defaultSessionName': defaultSessionName ?? '',
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      token: map['token'] as String,
      email: map['email'] as String,
      defaultSessionName: map['defaultSessionName'] != null ? map['defaultSessionName'] as String : null,
    );
  }

}
