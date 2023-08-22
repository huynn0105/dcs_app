// ignore_for_file: public_member_api_docs, sort_constructors_first

class ClientAccountDetailResponseDto {
  final List<RequirementAccount>? requirementAccount;
  final ClientAccount clientAccount;
  ClientAccountDetailResponseDto({
    this.requirementAccount,
    required this.clientAccount,
  });

  factory ClientAccountDetailResponseDto.fromMap(Map<String, dynamic> map) {
    return ClientAccountDetailResponseDto(
      requirementAccount: map['requirement_account'] != null
          ? List<RequirementAccount>.from(
              (map['requirement_account'] as List).map<RequirementAccount?>(
                (x) => RequirementAccount.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      clientAccount:
          ClientAccount.fromMap(map['client_account'] as Map<String, dynamic>),
    );
  }
}

class ClientAccount {
  final int id;
  final int clientId;
  final String? accountNumber;
  final String nickname;
  final String? username;
  ClientAccount({
    required this.id,
    required this.clientId,
    this.accountNumber,
    required this.nickname,
    this.username,
  });

  factory ClientAccount.fromMap(Map<String, dynamic> map) {
    return ClientAccount(
      id: map['id'] as int,
      clientId: map['client_id'] as int,
      accountNumber: map['account_number'] != null
          ? map['account_number'] as String
          : null,
      nickname: map['nickname'] as String,
      username: map['username'] != null ? map['username'] as String : null,
    );
  }
}

class RequirementAccount {
  final String requirementName;
  final int id;
  final String? value;
  RequirementAccount({
    required this.requirementName,
    required this.id,
    required this.value,
  });

  factory RequirementAccount.fromMap(Map<String, dynamic> map) {
    return RequirementAccount(
      requirementName: map['requirement_name'] as String,
      id: map['id'] as int,
      value: map['value'] != null ? map['value'] as String : null,
    );
  }
}
