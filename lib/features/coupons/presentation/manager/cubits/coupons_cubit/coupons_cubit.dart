import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/entities/pagination_entity.dart';
import 'package:deals/features/coupons/domain/repos/coupons_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  final CouponsRepo couponsRepo;
  int currentPage = 1;
  int limit = 10;
  String? search;
  String? sortField;
  String? sortOrder;

  CouponsCubit({required this.couponsRepo}) : super(CouponsInitial()) {
    fetchCouppons(isRefresh: true);
  }
  Future<void> fetchCouppons({
    bool isRefresh = false,
    String? search,
    String? sortField,
    String? sortOrder,
    int? limit,
    String? categoryId,
  }) async {
    if (search != null) this.search = search;
    if (sortField != null) this.sortField = sortField;
    if (sortOrder != null) this.sortOrder = sortOrder;
    if (limit != null) this.limit = limit;
    if (isRefresh) {
      // Full reload
      currentPage = 1;
      emit(CouponsLoading());
    } else {
      if (state is CouponsSuccess) {
        final successState = state as CouponsSuccess;
        // If no more pages, do nothing
        if (!successState.pagination.hasNextPage) {
          return;
        }
        // Otherwise, set partial loading
        emit(successState.copyWith(isLoadingMore: true));
      } else {
        emit(CouponsLoading());
      }
    }
    try {
      final eitherResult = await couponsRepo.getAllCoupons(
        search: this.search,
        sortField: this.sortField,
        sortOrder: this.sortOrder,
        page: currentPage,
        limit: this.limit,
      );
      eitherResult.fold((failure) {
        emit(CouponsFailure(message: failure.message));
      }, (coupons) {
        final newCoupons = coupons.coupons;
        final newPagination = coupons.pagination;
        if (isRefresh || state is! CouponsSuccess) {
          emit(
            CouponsSuccess(
              coupons: newCoupons,
              pagination: newPagination,
            ),
          );
        } else {
          final oldState = state as CouponsSuccess;
          final updatedCoupons = List<CouponEntity>.from(oldState.coupons)
            ..addAll(newCoupons);
          emit(
            oldState.copyWith(
              coupons: updatedCoupons,
              pagination: newPagination,
            ),
          );
        }
        if (newPagination.hasNextPage) currentPage++;
      });
    } catch (e) {
      emit(CouponsFailure(message: e.toString()));
    }
  }
}
