abstract class DatabaseService {
  /// Creates a new document or updates an existing one if [documentId] is provided.
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  });

  /// Retrieves data from the document at [path]/[documentId].
  Future<Map<String, dynamic>> getData({
    required String path,
    required String documentId,
  });

  /// Checks if the document exists at [path]/[documentId].
  Future<bool> checkIfDataExists({
    required String path,
    required String documentId,
  });

  /// Updates an existing document at [path]/[documentId] with [data].
  Future<void> updateData({
    required String path,
    required String documentId,
    required Map<String, dynamic> data,
  });

  /// Deletes the document at [path]/[documentId].
  Future<void> deleteData({
    required String path,
    required String documentId,
  });
}
