part of 'terms_cubit.dart';

abstract class TermsState {}

class TermsInitial extends TermsState {}

class TermsLoading extends TermsState {}

class TermsSuccess extends TermsState {
  final TermsDocument document;
  TermsSuccess(this.document);
}

class TermsFailure extends TermsState {
  final String message;
  TermsFailure(this.message);
}
