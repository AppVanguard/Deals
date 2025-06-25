import 'package:deals/features/privacy_and_policy/domain/models/privacy_policy_document.dart';
import 'package:deals/features/privacy_and_policy/domain/repos/privacy_policy_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'privacy_policy_state.dart';

class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  final PrivacyPolicyRepo repository;

  PrivacyPolicyCubit({required this.repository})
      : super(PrivacyPolicyInitial());

  Future<void> loadPolicy() async {
    emit(PrivacyPolicyLoading());
    try {
      final doc = await repository.loadPolicy();
      emit(PrivacyPolicySuccess(doc));
    } catch (e) {
      emit(PrivacyPolicyFailure(e.toString()));
    }
  }
}
