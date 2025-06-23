part of 'terms_cubit.dart';

@immutable
abstract class TermsState {}

class TermsInitial extends TermsState {}

class TermsLoading extends TermsState {}

class TermsSuccess extends TermsState {
  final List<String> terms;
  TermsSuccess({required this.terms});
}

class TermsFailure extends TermsState {
  final String message;
  TermsFailure({required this.message});
}
