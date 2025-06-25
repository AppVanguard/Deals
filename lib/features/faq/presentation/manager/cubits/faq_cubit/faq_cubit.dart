import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:deals/features/faq/data/faq_item.dart';
import 'package:deals/features/faq/domain/faq_repository.dart';
import 'package:meta/meta.dart';

part 'faq_state.dart';

/// Cubit responsible for loading FAQs using a [FaqRepository].
class FaqCubit extends SafeCubit<FaqState> {
  FaqCubit({required this.repository}) : super(FaqInitial());

  final FaqRepository repository;

  /// Loads FAQs from the repository and emits corresponding states.
  Future<void> loadFaqs() async {
    emit(FaqLoading());
    try {
      final faqs = await repository.loadFaqs();
      emit(FaqSuccess(faqs));
    } catch (e) {
      emit(FaqFailure(message: e.toString()));
    }
  }
}
