import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

/// Cubit for managing search query state.
class SearchCubit extends SafeCubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  /// Update the current search query.
  void updateQuery(String query) {
    emit(SearchUpdated(query: query));
  }
}
