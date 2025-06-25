import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:deals/features/faq/domain/models/faq_document.dart';
import 'package:deals/features/faq/domain/repos/faq_repository.dart';

part 'faq_state.dart';

class FaqCubit extends SafeCubit<FaqState> {
  final FaqRepository repository;

  FaqCubit({required this.repository}) : super(FaqInitial());

  Future<void> loadFaq() async {
    emit(FaqLoading());
    try {
      final doc = await repository.loadFaq();
      emit(FaqSuccess(doc));
    } catch (e) {
      emit(FaqFailure(e.toString()));
    }
  }
}
