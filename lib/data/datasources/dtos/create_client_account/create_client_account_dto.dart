class CreateClientAccountDto {
  final String token;
  final String client;
  final String username;
  final bool ppApp;
  final String submitType;
  final String email;
  final int? accountId;
  final List<ClientRequirementDtos>? clientRequirements;

  CreateClientAccountDto({
    required this.token,
    required this.client,
    required this.username,
    this.ppApp = true,
    this.submitType = 'save',
    this.accountId,
    this.clientRequirements,
    this.email = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'client': client,
      'pp_app': ppApp,
      'username': username,
      'submit_type': submitType,
      'account_id': accountId,
      'user_email': email,
      'client_requirements': clientRequirements?.map((x) => x.toMap()).toList(),
    };
  }
}

class ClientRequirementDtos {
  final int id;
  final String value;
  ClientRequirementDtos({
    required this.id,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'value': value,
    };
  }
}
