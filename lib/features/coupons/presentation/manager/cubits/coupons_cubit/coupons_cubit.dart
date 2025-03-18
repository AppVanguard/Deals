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

    // Handle loading more pages
    if (state is CouponsSuccess && !isRefresh) {
      final currentState = state as CouponsSuccess;
      if (!currentState.pagination.hasNextPage) return;
      emit(currentState.copyWith(isLoadingMore: true));
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
          final updatedCoupons = _getUpdatedCouponsList(
            couponsWithPagination.coupons,
            isRefresh,
          );

          emit(CouponsSuccess(
            coupons: updatedCoupons,
            pagination: couponsWithPagination.pagination,
          ));

          if (couponsWithPagination.pagination.hasNextPage) {
            _currentPage++;
          }
        },
      );
    } catch (e) {
      emit(CouponsFailure(message: e.toString()));
    }
  }

  /// Helper method to get the updated coupons list
  List<CouponEntity> _getUpdatedCouponsList(
    List<CouponEntity> newCoupons,
    bool isRefresh,
  ) {
    if (isRefresh || state is! CouponsSuccess) {
      return newCoupons;
    } else {
      final currentState = state as CouponsSuccess;
      return List.from(currentState.coupons)..addAll(newCoupons);
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
