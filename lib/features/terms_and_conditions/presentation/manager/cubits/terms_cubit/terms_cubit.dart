import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:deals/features/terms_and_conditions/domain/repos/terms_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'terms_state.dart';

class TermsCubit extends SafeCubit<TermsState> {
  final TermsRepo repo;
  TermsCubit({required this.repo}) : super(TermsInitial()) {
    loadTerms();
  }

  Future<void> loadTerms() async {
    emit(TermsLoading());
    try {
      final terms = await repo.loadTerms();
      emit(TermsSuccess(terms: terms));
    } catch (e) {
      emit(TermsFailure(message: e.toString()));
    }
  }
}
