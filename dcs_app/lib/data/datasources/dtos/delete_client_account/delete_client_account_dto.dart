
class DeleteClientAccountDto {
  final String token;
  final String client;
  final List<ClientAccountIds> clientAccountIds;
  
  const DeleteClientAccountDto({
    required this.token,
    required this.client,
    required this.clientAccountIds,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'client': client,
      'client_account_ids':
          clientAccountIds.map((client) => client.toMap()).toList(),
    };
  }
}

class ClientAccountIds {
  final int id;
  final bool isRequestAccount;
  const ClientAccountIds({
    required this.id,
    required this.isRequestAccount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'is_request_account': isRequestAccount,
    };
  }
}
