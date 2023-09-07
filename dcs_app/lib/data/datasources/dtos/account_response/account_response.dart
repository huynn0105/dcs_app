// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

class AccountResponse {
  final int id;
  @JsonKey(name: 'account_name')
  final String name;

  AccountResponse({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'account_name': name,
    };
  }

  factory AccountResponse.fromMap(Map<String, dynamic> map) {
    return AccountResponse(
      id: map['id'] as int,
      name: map['account_name'] as String,
    );
  }

  factory AccountResponse.fromJson(String source) =>
      AccountResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CRGResponse(id: $id, name: $name)';
}

List<AccountResponse> crgMockData = [
  AccountResponse(id: 1, name: '000 Test Account"s - address test'),
  AccountResponse(id: 12, name: '000 Test Account"s - Always Fin + Disclose'),
  AccountResponse(id: 13, name: '000 Test Account"s - Always Fin No Disclose'),
  AccountResponse(id: 14, name: '000 Test Account"s - Lots of Directives'),
  AccountResponse(
      id: 15, name: '000 Test Account"s - Often Fin No Req + Disclose - Dirs'),
  AccountResponse(
      id: 16, name: '000 Test Account"s - Often Fin No Req No DIsclose'),
  AccountResponse(id: 17, name: 'Eastern Bank'),
  AccountResponse(id: 18, name: 'eBay'),
  AccountResponse(id: 19, name: 'Eddie Bauer'),
  AccountResponse(id: 111, name: 'eHarmony'),
  AccountResponse(id: 122, name: 'Elder Scrolls Online'),
  AccountResponse(id: 133, name: 'Elephant.com'),
  AccountResponse(id: 144, name: 'OkCupid'),
  AccountResponse(id: 155, name: 'OneAmerica Retirement Services'),
  AccountResponse(id: 166, name: 'Facebook'),
  AccountResponse(id: 177, name: 'Fiduciary Trust Co'),
  AccountResponse(id: 188, name: 'Florida Extreme Adventures (FLX Adventures)'),
  AccountResponse(id: 199, name: 'Apple - AppleID, iTunes, Apple.com'),
  AccountResponse(id: 1111, name: 'Banana Republic'),
  AccountResponse(id: 1222, name: 'John Hancock'),
  AccountResponse(id: 1333, name: 'Joss and Main'),
  AccountResponse(id: 1444, name: 'Kimpton Hotels'),
  AccountResponse(
      id: 1555, name: 'VALIC - Variable Annuity Life Insurance Company'),
  AccountResponse(id: 1666, name: 'DropBox'),
  AccountResponse(id: 1777, name: 'National Online Insurance School'),
  AccountResponse(id: 1888, name: 'Yahoo! - Email, Flickr'),
];
