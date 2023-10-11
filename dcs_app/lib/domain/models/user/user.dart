import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String username;
  final String token;
  final String email;
  final String? defaultSessionName;
  final List<String> browsers;

  const User({
    required this.username,
    required this.token,
    required this.email,
    this.defaultSessionName,
    this.browsers = const [],
  });

  User copyWith({
    String? username,
    String? token,
    String? email,
    String? defaultSessionName,
    List<String>? browsers,
  }) {
    return User(
      username: username ?? this.username,
      token: token ?? this.token,
      email: email ?? this.email,
      defaultSessionName: defaultSessionName ?? this.defaultSessionName,
      browsers: browsers ?? this.browsers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'token': token,
      'email': email,
      'defaultSessionName': defaultSessionName ?? '',
      'browsers': jsonEncode(browsers),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      token: map['token'] as String,
      email: map['email'] as String,
      defaultSessionName: map['defaultSessionName'] != null ? map['defaultSessionName'] as String : null,
      browsers: List<String>.from((map['browsers'] as List<String>),
    ));
  }

}
