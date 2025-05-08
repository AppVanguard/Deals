import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/core/service/bookmark_service.dart';
import 'package:deals/features/bookmarks/data/bookmark_model/bookmark_model.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_pagination_entity.dart';
import 'package:deals/features/bookmarks/domain/mapper/bookmark_mapper.dart';
import 'package:deals/features/bookmarks/domain/mapper/bookmark_pagination_mapper.dart';

import 'package:deals/features/bookmarks/domain/repos/bookmark_repo.dart';
import 'package:deals/features/bookmarks/domain/repos/bookmarks_with_pagination.dart';

class BookmarkRepoImpl implements BookmarkRepo {
  final BookmarkService _service;

  BookmarkRepoImpl({required BookmarkService service}) : _service = service;

  @override
  Future<Either<Failure, BookmarksWithPaginationEntity>> getUserBookmarks(
    String token,
    String firebaseUid,
  ) async {
    try {
      final BookmarkModel model =
          await _service.getUserBookmarks(firebaseUid, token);

      // map the raw list → domain entities
      final List<BookmarkEntity> entities =
          BookmarksMapper.mapToEntities(model);

      // map pagination
      final BookmarkPaginationEntity pagination = model.pagination == null
          ? const BookmarkPaginationEntity(
              currentPage: 1, pageSize: 0, itemsCount: 0, totalPages: 1)
          : BookmarkPaginationMapper.mapToEntity(model.pagination!);

      return Right(
        BookmarksWithPaginationEntity(
          bookmarks: entities,
          pagination: pagination,
        ),
      );
    } catch (e, st) {
      log('Error in BookmarkRepoImpl.getUserBookmarks',
          error: e, stackTrace: st);
      return Left(ServerFaliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookmarkEntity>> createBookmark({
    required String token,
    required String firebaseUid,
    required String storeId,
  }) async {
    try {
      final data = await _service.createBookmark(
        token: token,
        firebaseUid: firebaseUid,
        storeId: storeId,
      );
      final entity = BookmarksMapper.mapToEntity(data);
      return Right(entity);
    } catch (e, st) {
      log('Error in BookmarkRepoImpl.createBookmark', error: e, stackTrace: st);
      return Left(ServerFaliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBookmark(String id, String token) async {
    try {
      await _service.deleteBookmark(id, token);
      return const Right(null);
    } catch (e, st) {
      log('Error in BookmarkRepoImpl.deleteBookmark', error: e, stackTrace: st);
      return Left(ServerFaliure(message: e.toString()));
    }
  }
}
