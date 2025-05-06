import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:deals/features/bookmarks/domain/repos/bookmarks_with_pagination.dart';

abstract class BookmarkRepo {
  /// Fetch all bookmarks for a given Firebase UID (with pagination).
  Future<Either<Failure, BookmarksWithPaginationEntity>> getUserBookmarks(
    String firebaseUid,
  );

  /// Create a new bookmark.
  Future<Either<Failure, BookmarkEntity>> createBookmark({
    required String firebaseUid,
    required String storeId,
  });

  /// Delete an existing bookmark by its ID.
  Future<Either<Failure, void>> deleteBookmark(String id);
}
