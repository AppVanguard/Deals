import 'dart:developer';

import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/core/entities/category_entity.dart';
import 'package:deals/core/widgets/build_custom_error_screen.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryTabBar extends StatefulWidget {
  /// Optional: Provide a callback if you want to respond when a tab is tapped.
  final ValueChanged<String>? onTabSelected;
  final void Function(String)? onTap;
  const CategoryTabBar({super.key, this.onTabSelected, this.onTap});

  @override
  State<CategoryTabBar> createState() => _CategoryTabBarState();
}

class _CategoryTabBarState extends State<CategoryTabBar> {
  // Internal flag to track if skeleton should be enabled.
  bool _skeletonEnabled = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        // Enable skeleton if we're still loading or in initial state.
        final bool newSkeletonEnabled =
            state is CategoriesLoading || state is CategoriesInitial;
        if (newSkeletonEnabled != _skeletonEnabled) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _skeletonEnabled = newSkeletonEnabled;
              });
            }
          });
        }

        if (state is CategoriesFailure) {
          return const SizedBox();
          // buildCustomErrorScreen(
          //     context: context,
          //     onRetry: () {
          //       context
          //           .read<CategoriesCubit>()
          //           .fetchCategories(isRefresh: true);
          //     });
        }

        // When categories are successfully loaded, we want to insert a tab for "All"
        final bool isSuccess = state is CategoriesSuccess;
        final List<CategoryEntity> categories =
            isSuccess ? state.categories : [];
        // If we have categories, increase the tab count by one for the "All" tab.
        final int totalItemCount = isSuccess ? (categories.length + 1) : 4;

        return Skeletonizer(
          enabled: _skeletonEnabled,
          child: DefaultTabController(
            length: totalItemCount,
            child: Builder(
              builder: (context) {
                final tabController = DefaultTabController.of(context);
                tabController.addListener(() {
                  final int currentIndex = tabController.index;
                  if (widget.onTabSelected != null &&
                      !tabController.indexIsChanging &&
                      currentIndex < totalItemCount) {
                    if (isSuccess) {
                      final String categoryId = currentIndex == 0
                          ? ''
                          : categories[currentIndex - 1].id;
                      log("Selected tab: $categoryId");
                      widget.onTabSelected!(categoryId);
                    } else {
                      widget.onTabSelected!(currentIndex.toString());
                    }
                  }
                });

                return Container(
                  color: Colors.white,
                  child: TabBar(
                    // onTap: widget.onTap,
                    isScrollable: true,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.green,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle:
                        const TextStyle(fontWeight: FontWeight.normal),
                    tabs: List.generate(totalItemCount, (index) {
                      if (isSuccess) {
                        if (index == 0) {
                          return Tab(text: S.of(context).All);
                        } else {
                          return Tab(text: categories[index - 1].title);
                        }
                      } else {
                        // While loading, show available categories or placeholders.
                        if (index < categories.length) {
                          return Tab(text: categories[index].title);
                        } else {
                          return Tab(
                            child: Container(
                              width: 50,
                              height: 16,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }
                      }
                    }),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
