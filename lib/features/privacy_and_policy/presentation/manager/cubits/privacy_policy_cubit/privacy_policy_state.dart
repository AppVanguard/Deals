part of 'privacy_policy_cubit.dart';

abstract class PrivacyPolicyState {}

class PrivacyPolicyInitial extends PrivacyPolicyState {}

class PrivacyPolicyLoading extends PrivacyPolicyState {}

class PrivacyPolicySuccess extends PrivacyPolicyState {
  final PrivacyPolicyDocument document;
  PrivacyPolicySuccess(this.document);
}

class PrivacyPolicyFailure extends PrivacyPolicyState {
  final String message;
  PrivacyPolicyFailure(this.message);
}
