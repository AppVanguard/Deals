import 'package:deals/features/terms_and_conditions/domain/models/terms_document.dart';
import 'package:deals/features/terms_and_conditions/domain/repos/terms_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'terms_state.dart';

class TermsCubit extends Cubit<TermsState> {
  final TermsRepo repository;

  TermsCubit({required this.repository}) : super(TermsInitial());

  Future<void> loadTerms() async {
    emit(TermsLoading());
    try {
      final doc = await repository.loadTerms();
      emit(TermsSuccess(doc));
    } catch (e) {
      emit(TermsFailure(e.toString()));
    }
  }
}
