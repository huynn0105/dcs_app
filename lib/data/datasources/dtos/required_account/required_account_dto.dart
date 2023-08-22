// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

class RequirementAccountDto {
  final int id;
  final String name;
  final String? description;
  @JsonKey(name: 'requirement_type')
  final String? requirementType;
  @JsonKey(name: 'data_field')
  final String? dataField;

  RequirementAccountDto({
    required this.id,
    required this.name,
    required this.description,
    required this.requirementType,
    required this.dataField,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'requirement_type': requirementType,
      'data_field': dataField,
    };
  }

  factory RequirementAccountDto.fromMap(Map<String, dynamic> map) {
    return RequirementAccountDto(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String?,
      requirementType: map['requirement_type'] as String?,
      dataField: map['data_field'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory RequirementAccountDto.fromJson(String source) =>
      RequirementAccountDto.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RequirementAccountDto(id: $id, name: $name, description: $description, requirementType: $requirementType, dataField: $dataField)';
  }
}
