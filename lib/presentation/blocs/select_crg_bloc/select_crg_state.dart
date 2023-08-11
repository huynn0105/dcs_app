part of 'select_crg_bloc.dart';

sealed class SelectCRGState {}

final class SelectCRGInitial extends SelectCRGState {}

final class SelectCRGFailed extends SelectCRGState {
  final String message;
  SelectCRGFailed({
    required this.message,
  });
}

final class SelectCRGLoading extends SelectCRGState {}

final class SelectCRGLoaded extends SelectCRGState {
  final List<CRGResponse> listCRGs;
  final List<CRGResponse> listCRGsSearched;
  SelectCRGLoaded({
    this.listCRGs = const [],
    this.listCRGsSearched = const [],
  });

  SelectCRGLoaded copyWith({
    List<CRGResponse>? listCRGs,
    List<CRGResponse>? listCRGsSearched,
  }) {
    return SelectCRGLoaded(
      listCRGs: listCRGs ?? this.listCRGs,
      listCRGsSearched: listCRGsSearched ?? this.listCRGsSearched,
    );
  }
}
