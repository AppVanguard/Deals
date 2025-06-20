import 'package:deals/core/manager/cubit/requires_user_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/entities/pagination_entity.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';
import 'package:deals/features/coupons/domain/repos/coupons_repo.dart';
import 'package:meta/meta.dart';

part 'store_details_state.dart';

class StoreDetailCubit extends Cubit<StoreDetailsState>
    with RequiresUser<StoreDetailsState> {
  final StoresRepo storesRepo;
  final CouponsRepo couponsRepo;

  // Pagination and filtering parameters
  int _currentPage = 1;
  final int _limit = 7; // Number of coupons per page
  String? _storeId;
  String? _search;
  String _sortField = 'title';
  String _sortOrder = 'asc';
  String? _category;
  String? _discountType;

  StoreDetailCubit({
    required this.storesRepo,
    required this.couponsRepo,
  }) : super(StoreDetailsInitial());

  /// Fetch store details and coupons by [storeId].
  /// Automatically triggers coupon fetching after store details are fetched.
  Future<void> getStoreAndCoupons(String storeId) async {
    emit(StoreDetailsLoading());
    final user = await requireUser((msg) => StoreDetailsFailure(message: msg));
    if (user == null) return;
    // Fetch store details
    final storeResult = await storesRepo.getStoreById(storeId, user.token);
    storeResult.fold(
      (failure) => emit(StoreDetailsFailure(message: failure.message)),
      (storeEntity) async {
        _storeId = storeId; // Save the storeId for fetching coupons

        // Fetch coupons for the store
        final couponsResult = await couponsRepo.getAllCoupons(
          search: _search,
          sortField: _sortField,
          page: _currentPage,
          limit: _limit,
          sortOrder: _sortOrder,
          category: _category,
          discountType: _discountType,
          storeId: _storeId, // Pass storeId to filter coupons by store
          token: user.token,
        );

        couponsResult.fold(
          (failure) => emit(StoreDetailsFailure(message: failure.message)),
          (couponsWithPagination) {
            emit(StoreDetailsSuccess(
              store: storeEntity,
              coupons: couponsWithPagination.coupons,
              pagination: couponsWithPagination.pagination,
            ));
          },
        );
      },
    );
  }

  /// Fetch the next page of coupons and append to the existing list.
  Future<void> loadNextPage() async {
    final user = await requireUser((msg) => StoreDetailsFailure(message: msg));
    if (user == null) return;

    if (state is StoreDetailsSuccess) {
      final currentState = state as StoreDetailsSuccess;
      if (!currentState.pagination.hasNextPage) return;

      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final result = await couponsRepo.getAllCoupons(
          search: _search,
          sortField: _sortField,
          page: _currentPage + 1, // Load the next page
          limit: _limit,
          sortOrder: _sortOrder,
          category: _category,
          discountType: _discountType,
          storeId: _storeId,
          token: user.token,
        );

        result.fold(
          (failure) => emit(StoreDetailsFailure(message: failure.message)),
          (couponsWithPagination) {
            final List<CouponEntity> updatedCoupons =
                List.from(currentState.coupons)
                  ..addAll(couponsWithPagination.coupons);

            emit(StoreDetailsSuccess(
              store: currentState.store,
              coupons: updatedCoupons,
              pagination: couponsWithPagination.pagination,
            ));

            if (couponsWithPagination.pagination.hasNextPage) {
              _currentPage++;
            }
          },
        );
      } catch (e) {
        emit(StoreDetailsFailure(message: e.toString()));
      }
    }
  }

  /// Update filters and refresh the coupons list.
  void updateFilters({
    String? search,
    String? sortField,
    String? sortOrder,
    String? category,
    String? discountType,
  }) {
    _search = search;
    if (sortField != null) _sortField = sortField;
    if (sortOrder != null) _sortOrder = sortOrder;
    _category = category;
    _discountType = discountType;

    _currentPage = 1;
    if (_storeId != null) {
      getStoreAndCoupons(_storeId!);
    }
  }
}
