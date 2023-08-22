// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'account_detail_bloc.dart';

sealed class AccountDetailEvent {}

class AccountDetailInitEvent extends AccountDetailEvent {
  final Account account;
  AccountDetailInitEvent({
    required this.account,
  });
}

class RequestAccountDetailUpdateEvent extends AccountDetailEvent {
  final int id;
  final String accountNumber;
  final String username;
  final String nickname;

  RequestAccountDetailUpdateEvent({
    required this.id,
    required this.accountNumber,
    required this.username,
    required this.nickname,
  });
}
class AccountDetailUpdateEvent extends AccountDetailEvent {
  final UpdateClientAccount clientAccount;

  AccountDetailUpdateEvent({
    required this.clientAccount,
  });
}
