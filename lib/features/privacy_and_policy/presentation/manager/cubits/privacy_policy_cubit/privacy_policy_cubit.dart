import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:deals/features/privacy_and_policy/data/privacy_policy_repository.dart';
import 'package:meta/meta.dart';

part 'privacy_policy_state.dart';

/// Cubit responsible for loading privacy policy terms.
class PrivacyPolicyCubit extends SafeCubit<PrivacyPolicyState> {
  PrivacyPolicyCubit({required this.repository}) : super(PrivacyPolicyInitial());

  final PrivacyPolicyRepository repository;

  /// Loads the terms from the repository and emits corresponding states.
  Future<void> loadPolicy() async {
    emit(PrivacyPolicyLoading());
    try {
      final terms = await repository.loadTerms();
      emit(PrivacyPolicySuccess(terms));
    } catch (e) {
      emit(PrivacyPolicyFailure(message: e.toString()));
    }
  }
}
