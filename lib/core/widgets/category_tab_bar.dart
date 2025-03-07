import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';


class CategoryTabBar extends StatelessWidget {
  /// Optional: Provide a callback if you want to respond when a tab is tapped.
  final ValueChanged<int>? onTabSelected;

  const CategoryTabBar({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        // 1) If failure => show error text
        if (state is CategoriesFailure) {
          return Center(child: Text(state.message));
        }

        // 2) If loading => show skeleton for the entire tab bar
        if (state is CategoriesLoading || state is CategoriesInitial) {
          return _buildFullSkeleton();
        }

        // 3) If success => build the real tab bar, plus placeholders if isLoadingMore
        if (state is CategoriesSuccess) {
          final categories = state.categories;
          // If the cubit is currently loading more data (pagination),
          // we can show some placeholder tabs at the end.
          final placeholdersCount = state.isLoadingMore ? 3 : 0;
          final totalItemCount = categories.length + placeholdersCount;

          // Use a DefaultTabController so that we can display the tabs.
          return DefaultTabController(
            length: totalItemCount,
            child: Builder(
              builder: (context) {
                final tabController = DefaultTabController.of(context);
                // Listen for tab changes if needed
                tabController?.addListener(() {
                  if (onTabSelected != null &&
                      !tabController.indexIsChanging &&
                      tabController.index < categories.length) {
                    onTabSelected!(tabController.index);
                  }
                });

                return Container(
                  color: Colors.white,
                  child: TabBar(
                    isScrollable: true,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.green,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle:
                        const TextStyle(fontWeight: FontWeight.normal),
                    tabs: List.generate(totalItemCount, (index) {
                      // If index is within the real categories, show the actual title
                      if (index < categories.length) {
                        final category = categories[index];
                        return Tab(text: category.title);
                      } else {
                        // For placeholders, show a skeleton tab
                        return Tab(
                          child: Skeletonizer(
                            enabled: true,
                            child: Container(
                              width: 50,
                              height: 16,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                );
              },
            ),
          );
        }

        // Fallback for any other state (e.g. if not handled).
        return const SizedBox.shrink();
      },
    );
  }

  /// Builds a full-width skeleton for the entire tab bar (used on initial load).
  Widget _buildFullSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(4, (index) {
            return Container(
              width: 60,
              height: 16,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ),
    );
  }
}
