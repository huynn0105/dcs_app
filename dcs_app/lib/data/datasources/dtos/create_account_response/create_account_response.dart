import 'dart:convert';

class CreateAccountReponse {
  final int id;
  final bool success;
  CreateAccountReponse({
    required this.id,
    required this.success,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'success': success,
    };
  }

  factory CreateAccountReponse.fromMap(Map<String, dynamic> map) {
    return CreateAccountReponse(
      id: map['id'] as int,
      success: map['success'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAccountReponse.fromJson(String source) =>
      CreateAccountReponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
