import 'dart:convert';
import 'package:deals/features/privacy_and_policy/domain/models/privacy_policy_document.dart';
import 'package:deals/features/privacy_and_policy/domain/repos/privacy_policy_repo.dart';
import 'package:flutter/services.dart';


class JsonPrivacyPolicyRepository implements PrivacyPolicyRepo {
  const JsonPrivacyPolicyRepository();

  @override
  Future<PrivacyPolicyDocument> loadPolicy() async {
    final jsonStr = await rootBundle.loadString(
      'assets/json/privacy_policy.json',
    );
    final Map<String, dynamic> data = json.decode(jsonStr);
    return PrivacyPolicyDocument.fromJson(data);
  }
}
