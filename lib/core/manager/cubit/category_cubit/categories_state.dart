part of 'categories_cubit.dart';

@immutable
abstract class CategoriesState {}

/// Initial state – no data yet.
class CategoriesInitial extends CategoriesState {}

/// Full refresh or first load.
class CategoriesLoading extends CategoriesState {}

/// Success state holding a list of categories along with pagination data.
class CategoriesSuccess extends CategoriesState {
  final List<CategoryEntity> categories;
  final PaginationEntity pagination;
  final bool isLoadingMore;

  CategoriesSuccess({
    required this.categories,
    required this.pagination,
    this.isLoadingMore = false,
  });

  CategoriesSuccess copyWith({
    List<CategoryEntity>? categories,
    PaginationEntity? pagination,
    bool? isLoadingMore,
  }) {
    return CategoriesSuccess(
      categories: categories ?? this.categories,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Failure state with an error message.
class CategoriesFailure extends CategoriesState {
  final String message;
  CategoriesFailure({required this.message});
}
