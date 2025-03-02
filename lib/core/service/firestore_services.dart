import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deals/core/service/database_service.dart';

/// An implementation of [DatabaseService] using Cloud Firestore.
/// Provides general-purpose CRUD operations.
class FirestoreServices implements DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Add data to a Firestore collection. If [documentId] is provided,
  /// the document is set (overwriting existing data). If null, a new doc is added.
  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    if (documentId != null) {
      await firestore.collection(path).doc(documentId).set(data);
    } else {
      await firestore.collection(path).add(data);
    }
  }

  /// Get data from Firestore for a given path and [documentId].
  @override
  Future<Map<String, dynamic>> getData({
    required String path,
    required String documentId,
  }) async {
    var snapshot = await firestore.collection(path).doc(documentId).get();
    return snapshot.data() ?? {};
  }

  /// Check if a document exists for a given [path] and [documentId].
  @override
  Future<bool> checkIfDataExists({
    required String path,
    required String documentId,
  }) async {
    var doc = await firestore.collection(path).doc(documentId).get();
    return doc.exists;
  }

  @override
  Future<void> deleteData({required String path, required String documentId}) {
    // TODO: implement deleteData
    throw UnimplementedError();
  }

  @override
  Future<void> updateData(
      {required String path,
      required String documentId,
      required Map<String, dynamic> data}) {
    // TODO: implement updateData
    throw UnimplementedError();
  }
}
