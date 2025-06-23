import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:deals/features/settings/data/repos/delete_account_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'delete_reasons_state.dart';

/// Cubit responsible for loading delete account reasons.
class DeleteReasonsCubit extends SafeCubit<DeleteReasonsState> {
  DeleteReasonsCubit({required this.repository}) : super(DeleteReasonsInitial());

  final DeleteAccountRepository repository;

  /// Loads reasons from the repository and emits corresponding states.
  Future<void> loadReasons() async {
    emit(DeleteReasonsLoading());
    try {
      final reasons = await repository.loadReasons();
      emit(DeleteReasonsSuccess(reasons));
    } catch (e) {
      emit(DeleteReasonsFailure(message: e.toString()));
    }
  }
}
