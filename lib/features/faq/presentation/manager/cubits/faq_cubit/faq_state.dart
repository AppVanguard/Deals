part of 'faq_cubit.dart';

abstract class FaqState {}

class FaqInitial extends FaqState {}

class FaqLoading extends FaqState {}

class FaqSuccess extends FaqState {
  final FaqDocument document;
  FaqSuccess(this.document);
}

class FaqFailure extends FaqState {
  final String message;
  FaqFailure(this.message);
}
