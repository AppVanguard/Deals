import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:deals/features/terms_and_conditions/domain/repos/terms_repo.dart';
import 'package:meta/meta.dart';

part 'terms_state.dart';

class TermsCubit extends SafeCubit<TermsState> {
  final TermsRepo repository;

  TermsCubit({required this.repository}) : super(TermsInitial());

  Future<void> loadTerms() async {
    emit(TermsLoading());
    try {
      final terms = await repository.loadTerms();
      emit(TermsSuccess(terms: terms));
    } catch (e) {
      emit(TermsFailure(message: e.toString()));
    }
  }
}
