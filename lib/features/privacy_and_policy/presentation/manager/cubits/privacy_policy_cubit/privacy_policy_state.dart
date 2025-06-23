part of 'privacy_policy_cubit.dart';

@immutable
sealed class PrivacyPolicyState {}

final class PrivacyPolicyInitial extends PrivacyPolicyState {}

final class PrivacyPolicyLoading extends PrivacyPolicyState {}

final class PrivacyPolicySuccess extends PrivacyPolicyState {
  PrivacyPolicySuccess(this.terms);
  final List<String> terms;
}

final class PrivacyPolicyFailure extends PrivacyPolicyState {
  PrivacyPolicyFailure({required this.message});
  final String message;
}
