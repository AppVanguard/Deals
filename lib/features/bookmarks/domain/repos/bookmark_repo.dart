import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:deals/features/bookmarks/domain/repos/bookmarks_with_pagination.dart';

abstract class BookmarkRepo {
  Future<Either<Failure, BookmarksWithPaginationEntity>> getUserBookmarks({
    required String firebaseUid,
    required String token,
    required int page,
    required int limit,
    String search,
    List<String> categories,
    bool hasCoupons,
    bool hasCashback,
    String sortOrder,
  });

  Future<Either<Failure, BookmarkEntity>> createBookmark({
    required String firebaseUid,
    required String storeId,
    required String token,
  });

  Future<Either<Failure, void>> deleteBookmark({
    required String bookmarkId,
    required String token,
  });
}
