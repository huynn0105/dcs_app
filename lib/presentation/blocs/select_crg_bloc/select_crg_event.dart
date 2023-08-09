part of 'select_crg_bloc.dart';

@immutable
sealed class SelectCRGEvent {}

final class SelectCRGInitEvent extends SelectCRGEvent {}

final class SelectCRGSearchEvent extends SelectCRGEvent {
  final String searchQuery;

  SelectCRGSearchEvent({
    required this.searchQuery,
  });
}
