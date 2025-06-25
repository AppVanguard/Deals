import 'package:deals/core/manager/cubit/requires_user_mixin.dart';
import 'package:deals/core/repos/interface/categories_repo.dart';
import 'package:deals/core/manager/cubit/safe_cubit.dart';
import 'package:meta/meta.dart';
import 'package:deals/core/entities/pagination_entity.dart';
import 'package:deals/core/entities/category_entity.dart';

part 'categories_state.dart';

class CategoriesCubit extends SafeCubit<CategoriesState>
    with RequiresUser<CategoriesState> {
  final CategoriesRepo categoriesRepo;
  // Local tracking for pagination parameters.
  int currentPage = 1;
  int limit = 10;
  String? sortField;
  String? sortOrder;

  CategoriesCubit({required this.categoriesRepo}) : super(CategoriesInitial()) {
    // Immediately fetch the initial set of categories.
    fetchCategories(isRefresh: true);
  }

  Future<void> fetchCategories({
    bool isRefresh = false,
    String? sortField,
    String? sortOrder,
    int? limit,
  }) async {
    // Update optional query parameters.
    if (sortField != null) this.sortField = sortField;
    if (sortOrder != null) this.sortOrder = sortOrder;
    if (limit != null) this.limit = limit;

    if (isRefresh) {
      // Reset pagination.
      currentPage = 1;
      emit(CategoriesLoading());
    } else {
      // Load next page if possible.
      if (state is CategoriesSuccess) {
        final successState = state as CategoriesSuccess;
        if (!successState.pagination.hasNextPage) {
          return;
        }
        emit(successState.copyWith(isLoadingMore: true));
      } else {
        emit(CategoriesLoading());
      }
    }

    try {
      final user = await requireUser((msg) => CategoriesFailure(message: msg));
      if (user == null) return;
      final eitherResult = await categoriesRepo.getAllCategories(
        sortField: this.sortField,
        sortOrder: this.sortOrder,
        page: currentPage,
        limit: this.limit,
        token: user.token,
      );

      eitherResult.fold(
        (failure) {
          emit(CategoriesFailure(message: failure.message));
        },
        (categoriesWithPagination) {
          final newCategories = categoriesWithPagination.categories;
          final newPagination = categoriesWithPagination.pagination;

          if (isRefresh || state is! CategoriesSuccess) {
            // Replace entire list.
            emit(CategoriesSuccess(
              categories: newCategories,
              pagination: newPagination,
            ));
          } else {
            // Append new categories to the existing list.
            final oldState = state as CategoriesSuccess;
            final updatedCategories =
                List<CategoryEntity>.from(oldState.categories)
                  ..addAll(newCategories);
            emit(oldState.copyWith(
              categories: updatedCategories,
              pagination: newPagination,
              isLoadingMore: false,
            ));
          }

          // Increment page if there's a next page.
          if (newPagination.hasNextPage) {
            currentPage++;
          }
        },
      );
    } catch (e) {
      emit(CategoriesFailure(message: e.toString()));
    }
  }
}
