// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CRGResponse {
  final int id;
  final String name;

  CRGResponse({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory CRGResponse.fromMap(Map<String, dynamic> map) {
    return CRGResponse(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  factory CRGResponse.fromJson(String source) => CRGResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CRGResponse(id: $id, name: $name)';
}

List<CRGResponse> crgMockData = [
  CRGResponse(id: 1, name: '000 Test Account"s - address test'),
  CRGResponse(id: 12, name: '000 Test Account"s - Always Fin + Disclose'),
  CRGResponse(id: 13, name: '000 Test Account"s - Always Fin No Disclose'),
  CRGResponse(id: 14, name: '000 Test Account"s - Lots of Directives'),
  CRGResponse(
      id: 15, name: '000 Test Account"s - Often Fin No Req + Disclose - Dirs'),
  CRGResponse(
      id: 16, name: '000 Test Account"s - Often Fin No Req No DIsclose'),
  CRGResponse(id: 17, name: 'Eastern Bank'),
  CRGResponse(id: 18, name: 'eBay'),
  CRGResponse(id: 19, name: 'Eddie Bauer'),
  CRGResponse(id: 111, name: 'eHarmony'),
  CRGResponse(id: 122, name: 'Elder Scrolls Online'),
  CRGResponse(id: 133, name: 'Elephant.com'),
  CRGResponse(id: 144, name: 'OkCupid'),
  CRGResponse(id: 155, name: 'OneAmerica Retirement Services'),
  CRGResponse(id: 166, name: 'Facebook'),
  CRGResponse(id: 177, name: 'Fiduciary Trust Co'),
  CRGResponse(id: 188, name: 'Florida Extreme Adventures (FLX Adventures)'),
  CRGResponse(id: 199, name: 'Apple - AppleID, iTunes, Apple.com'),
  CRGResponse(id: 1111, name: 'Banana Republic'),
  CRGResponse(id: 1222, name: 'John Hancock'),
  CRGResponse(id: 1333, name: 'Joss and Main'),
  CRGResponse(id: 1444, name: 'Kimpton Hotels'),
  CRGResponse(
      id: 1555, name: 'VALIC - Variable Annuity Life Insurance Company'),
  CRGResponse(id: 1666, name: 'DropBox'),
  CRGResponse(id: 1777, name: 'National Online Insurance School'),
  CRGResponse(id: 1888, name: 'Yahoo! - Email, Flickr'),
];
