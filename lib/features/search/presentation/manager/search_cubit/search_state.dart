part of 'search_cubit.dart';

@immutable
sealed class SearchState {
  const SearchState();
  String get query => '';
}

final class SearchInitial extends SearchState {
  const SearchInitial();
}

final class SearchUpdated extends SearchState {
  final String query;
  const SearchUpdated({required this.query});
}
