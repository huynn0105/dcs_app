part of 'create_account_bloc.dart';

sealed class CreateAccountState {}

final class CreateAccountInitial extends CreateAccountState {}

final class CreateAccountLoaded extends CreateAccountState {
  final List<CRGResponse> listCRGs;
  final List<CRGResponse> listCRGsSearched;
  CreateAccountLoaded({
    this.listCRGs = const [],
    this.listCRGsSearched = const [],
  });

  CreateAccountLoaded copyWith({
    List<CRGResponse>? listCRGs,
    List<CRGResponse>? listCRGsSearched,
  }){
    return CreateAccountLoaded(
      listCRGs: listCRGs ?? this.listCRGs,
      listCRGsSearched: listCRGsSearched ?? this.listCRGsSearched,
    );
  }
}



final class CreateAccountFailed extends CreateAccountState {
  final String message;
  CreateAccountFailed({
    required this.message,
  });
}

final class CreateAccountLoading extends CreateAccountState {}
