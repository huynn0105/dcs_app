part of 'select_account_bloc.dart';

sealed class SelectAccountEvent {}

final class SelectAccountInitEvent extends SelectAccountEvent {
  final bool isRefresh;
  SelectAccountInitEvent({this.isRefresh = false});
}

final class SelectAccountSearchEvent extends SelectAccountEvent {
  final String searchQuery;

  SelectAccountSearchEvent({
    required this.searchQuery,
  });
}
