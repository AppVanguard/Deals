part of 'faq_cubit.dart';

@immutable
sealed class FaqState {}

final class FaqInitial extends FaqState {}

final class FaqLoading extends FaqState {}

final class FaqSuccess extends FaqState {
  FaqSuccess(this.faqs);
  final List<FAQItem> faqs;
}

final class FaqFailure extends FaqState {
  FaqFailure({required this.message});
  final String message;
}
