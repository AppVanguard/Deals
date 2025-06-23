import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:deals/features/terms_and_conditions/data/terms_and_conditions_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'terms_state.dart';

/// Cubit responsible for loading terms and conditions.
class TermsCubit extends SafeCubit<TermsState> {
  TermsCubit({required this.repository}) : super(TermsInitial());

  final TermsRepository repository;

  /// Loads terms from the repository and emits corresponding states.
  Future<void> loadTerms() async {
    emit(TermsLoading());
    try {
      final terms = await repository.loadTerms();
      emit(TermsSuccess(terms));
    } catch (e) {
      emit(TermsFailure(message: e.toString()));
    }
  }
}
