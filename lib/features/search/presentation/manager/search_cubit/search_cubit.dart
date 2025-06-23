import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

/// Cubit for managing search query state.
class SearchCubit extends SafeCubit<SearchState> {
  SearchCubit() : super(const SearchInitial());

  /// Update the current search query.
  void updateQuery(String query) {
    emit(SearchUpdated(query: query));
  }
}
