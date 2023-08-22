part of 'select_account_bloc.dart';

sealed class SelectAccountEvent {}

final class SelectAccountInitEvent extends SelectAccountEvent {}

final class SelectAccountSearchEvent extends SelectAccountEvent {
  final String searchQuery;

  SelectAccountSearchEvent({
    required this.searchQuery,
  });
}
