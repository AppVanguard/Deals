part of 'terms_cubit.dart';

@immutable
sealed class TermsState {}

final class TermsInitial extends TermsState {}

final class TermsLoading extends TermsState {}

final class TermsSuccess extends TermsState {
  TermsSuccess(this.terms);
  final List<String> terms;
}

final class TermsFailure extends TermsState {
  TermsFailure({required this.message});
  final String message;
}
