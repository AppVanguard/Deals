import 'package:deals/core/utils/dev_log.dart';

import 'package:dartz/dartz.dart';
import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/entities/pagination_entity.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/core/mappers/pagination_mapper.dart';
import 'package:deals/core/service/coupons_service.dart';
import 'package:deals/features/coupons/data/models/coupons_model.dart';
import 'package:deals/features/coupons/domain/mapper/coupons_mapper.dart';
import 'package:deals/features/coupons/domain/repos/coupons_repo.dart';
import 'package:deals/features/coupons/domain/repos/coupons_with_pagination.dart';

class CouponsRepoImpl implements CouponsRepo {
  final CouponsService couponsService;

  CouponsRepoImpl({required this.couponsService});
  @override
  Future<Either<Failure, CouponsWithPaginationEntity>> getAllCoupons({
    String? search,
    String? sortField,
    int? page,
    int? limit,
    String? sortOrder,
    String? category,
    String? discountType,
    String? storeId,
    required String token,
  }) async {
    try {
      final CouponsModel couponsModel = await couponsService.getAllCoupons(
        search: search,
        sortField: sortField,
        page: page,
        limit: limit,
        sortOrder: sortOrder,
        category: category,
        discountType: discountType,
        storeId: storeId,
        token: token,
      );
      final List<CouponEntity> couponEntities =
          CouponsMapper.mapToEntities(couponsModel);
      final paginationModel = couponsModel.pagination;
      final paginationEntity = paginationModel == null
          ? const PaginationEntity(
              currentPage: 1,
              totalPages: 1,
              totalStores: 0,
              hasNextPage: false,
              hasPrevPage: false,
            )
          : PaginationMapper.mapToEntity(paginationModel);
      final result = CouponsWithPaginationEntity(
          coupons: couponEntities, pagination: paginationEntity);
      return Right(result);
    } catch (e) {
      log('Error in couponsRepoImpl: ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CouponEntity>> getCouponById(
      String id, String token) async {
    try {
      final CouponsModel couponsModel =
          await couponsService.getCouponById(id, token);
      if (couponsModel.data != null && couponsModel.data!.isNotEmpty) {
        final couponEntity =
            CouponsMapper.mapToEntity(couponsModel.data!.first);
        return Right(couponEntity);
      } else {
        throw Exception('Coupon not found');
      }
    } catch (e) {
      log('Error in couponsRepoImpl: ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
