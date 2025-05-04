import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

abstract class DeleteAccountRepository {
  /// Loads the list of reasons/warnings for deleting an account.
  Future<List<String>> loadReasons();
}

class JsonDeleteAccountRepository implements DeleteAccountRepository {
  @override
  Future<List<String>> loadReasons() async {
    final jsonStr = await rootBundle.loadString(
      'assets/json/delete_account_reasons.json',
    );
    final Map<String, dynamic> data = json.decode(jsonStr);
    return List<String>.from(data['delete_reasons'] as List);
  }
}
