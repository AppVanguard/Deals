import 'package:deals/core/utils/dev_log.dart';
import 'package:dartz/dartz.dart';

import 'package:deals/core/errors/failure.dart';
import 'package:deals/core/service/bookmark_service.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_pagination_entity.dart';
import 'package:deals/features/bookmarks/domain/mapper/bookmark_mapper.dart';
import 'package:deals/features/bookmarks/domain/mapper/bookmark_pagination_mapper.dart';
import 'package:deals/features/bookmarks/domain/repos/bookmark_repo.dart';
import 'package:deals/features/bookmarks/domain/repos/bookmarks_with_pagination.dart';
import 'package:deals/features/bookmarks/data/bookmark_model/bookmark_model.dart';

class BookmarkRepoImpl implements BookmarkRepo {
  final BookmarkService service;
  BookmarkRepoImpl({required this.service});

  @override
  Future<Either<Failure, BookmarksWithPaginationEntity>> getUserBookmarks({
    required String firebaseUid,
    required String token,
    required int page,
    required int limit,
    String search = '',
    List<String> categories = const [],
    bool hasCoupons = false,
    bool hasCashback = false,
    String sortOrder = 'asc',
  }) async {
    try {
      final BookmarkModel model = await service.getUserBookmarks(
        firebaseUid: firebaseUid,
        token: token,
        page: page,
        limit: limit,
        search: search,
        categories: categories,
        hasCoupons: hasCoupons,
        hasCashback: hasCashback,
        sortOrder: sortOrder,
      );

      return Right(BookmarksWithPaginationEntity(
        bookmarks: BookmarksMapper.mapToEntities(model),
        pagination: model.pagination == null
            ? const BookmarkPaginationEntity(
                currentPage: 1, pageSize: 0, itemsCount: 0, totalPages: 1)
            : BookmarkPaginationMapper.mapToEntity(model.pagination!),
      ));
    } catch (e, st) {
      log('BookmarkRepoImpl.getUserBookmarks', error: e, stackTrace: st);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookmarkEntity>> createBookmark({
    required String firebaseUid,
    required String storeId,
    required String token,
  }) async {
    try {
      final data = await service.createBookmark(
        firebaseUid: firebaseUid,
        storeId: storeId,
        token: token,
      );
      return Right(BookmarksMapper.mapToEntity(data));
    } catch (e, st) {
      log('BookmarkRepoImpl.createBookmark', error: e, stackTrace: st);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBookmark({
    required String bookmarkId,
    required String token,
  }) async {
    try {
      await service.deleteBookmark(bookmarkId: bookmarkId, token: token);
      return const Right(null);
    } catch (e, st) {
      log('BookmarkRepoImpl.deleteBookmark', error: e, stackTrace: st);
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
