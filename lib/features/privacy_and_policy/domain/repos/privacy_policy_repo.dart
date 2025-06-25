import '../models/privacy_policy_document.dart';

abstract class PrivacyPolicyRepo {
  Future<PrivacyPolicyDocument> loadPolicy();
}
