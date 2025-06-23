part of 'delete_reasons_cubit.dart';

@immutable
sealed class DeleteReasonsState {}

final class DeleteReasonsInitial extends DeleteReasonsState {}

final class DeleteReasonsLoading extends DeleteReasonsState {}

final class DeleteReasonsSuccess extends DeleteReasonsState {
  DeleteReasonsSuccess(this.reasons);
  final List<String> reasons;
}

final class DeleteReasonsFailure extends DeleteReasonsState {
  DeleteReasonsFailure({required this.message});
  final String message;
}
