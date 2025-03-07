import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/core/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryTabBar extends StatefulWidget {
  /// Optional: Provide a callback if you want to respond when a tab is tapped.
  final ValueChanged<int>? onTabSelected;
  final void Function(int)? onTap;
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
        // Determine if skeleton should be enabled based on state.
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
          return Center(child: Text(state.message));
        }

        // Use available categories if present; otherwise, default to a count of 4.
        final List<CategoryEntity> categories =
            state is CategoriesSuccess ? state.categories : [];
        final int totalItemCount =
            categories.isNotEmpty ? categories.length : 4;

        // The entire real widget (DefaultTabController with TabBar) is wrapped in a Skeletonizer.
        return Skeletonizer(
          enabled: _skeletonEnabled,
          child: DefaultTabController(
            length: totalItemCount,
            child: Builder(
              builder: (context) {
                final tabController = DefaultTabController.of(context);
                tabController.addListener(() {
                  if (widget.onTabSelected != null &&
                      !tabController.indexIsChanging &&
                      tabController.index < categories.length) {
                    widget.onTabSelected!(tabController.index);
                  }
                });
                return Container(
                  color: Colors.white,
                  child: TabBar(
                    onTap: widget.onTap,
                    isScrollable: true,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.green,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle:
                        const TextStyle(fontWeight: FontWeight.normal),
                    tabs: List.generate(totalItemCount, (index) {
                      if (index < categories.length) {
                        return Tab(text: categories[index].title);
                      } else {
                        // Instead of an empty tab, provide a visible placeholder container.
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
