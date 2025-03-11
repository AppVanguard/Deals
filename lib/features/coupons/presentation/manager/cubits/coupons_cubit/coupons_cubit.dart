import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/entities/pagination_entity.dart';
import 'package:deals/features/coupons/domain/repos/coupons_repo.dart';

part 'coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  final CouponsRepo couponsRepo;

  // Internal parameters for filtering, sorting, and pagination.
  int _currentPage = 1;
  String? _search;
  String _sortField = 'title';
  String _sortOrder = 'asc';
  int _limit = 5;
  String? _category;
  String? _discountType;

  CouponsCubit({required this.couponsRepo}) : super(CouponsInitial()) {
    loadCoupons(isRefresh: true);
  }

  /// Loads coupons data.
  /// If [isRefresh] is true, resets the pagination to the first page.
  Future<void> loadCoupons({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
    }

    // When loading more pages, check the current state.
    if (state is CouponsSuccess && !isRefresh) {
      final currentState = state as CouponsSuccess;
      if (!currentState.pagination.hasNextPage) return;
      emit(CouponsSuccess(
        coupons: currentState.coupons,
        pagination: currentState.pagination,
        isLoadingMore: true,
      ));
    } else {
      emit(CouponsLoading());
    }

    try {
      final result = await couponsRepo.getAllCoupons(
        search: _search,
        sortField: _sortField,
        page: _currentPage,
        limit: _limit,
        sortOrder: _sortOrder,
        category: _category,
        discountType: _discountType,
      );

      result.fold(
        (failure) => emit(CouponsFailure(message: failure.message)),
        (couponsWithPagination) {
          List<CouponEntity> updatedCoupons = [];
          if (isRefresh || state is! CouponsSuccess) {
            // Fresh load (or refresh) replaces the current list.
            updatedCoupons = couponsWithPagination.coupons;
          } else if (state is CouponsSuccess) {
            // Append new items to the existing list.
            final currentState = state as CouponsSuccess;
            updatedCoupons = List.from(currentState.coupons)
              ..addAll(couponsWithPagination.coupons);
          }

          emit(CouponsSuccess(
            coupons: updatedCoupons,
            pagination: couponsWithPagination.pagination,
            isLoadingMore: false,
          ));

          // If more pages are available, increment the page.
          if (couponsWithPagination.pagination.hasNextPage) {
            _currentPage++;
          }
        },
      );
    } catch (e) {
      emit(CouponsFailure(message: e.toString()));
    }
  }

  /// Updates filtering, sorting, and pagination parameters, then refreshes the coupons.
  void updateFilters({
    String? search,
    String? sortField,
    String? sortOrder,
    int? limit,
    String? category,
    String? discountType,
  }) {
    _search = search;
    if (sortField != null) _sortField = sortField;
    if (sortOrder != null) _sortOrder = sortOrder;
    if (limit != null) _limit = limit;
    _category = category;
    _discountType = discountType;

    _currentPage = 1;
    loadCoupons(isRefresh: true);
  }

  /// Loads the next page if available.
  Future<void> loadNextPage() async {
    if (state is CouponsSuccess) {
      final currentState = state as CouponsSuccess;
      if (currentState.pagination.hasNextPage) {
        await loadCoupons();
      }
    }
  }
}
