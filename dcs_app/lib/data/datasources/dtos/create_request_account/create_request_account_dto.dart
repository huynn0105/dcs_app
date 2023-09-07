// ignore_for_file: public_member_api_docs, sort_constructors_first

class CreateRequestAccountDto {
  final String token;
  final String client;
  final String username;
  final bool ppApp;
  final String url;
  final String submitType;
  final String accountNumber;

  CreateRequestAccountDto({
    required this.token,
    required this.client,
    required this.username,
    this.ppApp = true,
    required this.url,
    this.submitType = 'save',
    this.accountNumber = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'client': client,
      'username': username,
      'pp_app': ppApp,
      'url': url,
      'submit_type': submitType,
      'account_number': accountNumber,
    };
  }
}
