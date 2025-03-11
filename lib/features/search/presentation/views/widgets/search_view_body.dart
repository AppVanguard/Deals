import 'dart:async';
import 'dart:developer';
import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/core/widgets/build_custom_error_screen.dart';
import 'package:deals/core/widgets/category_tab_bar.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/widgets/generic_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchViewBody extends StatefulWidget {
  const SearchViewBody({super.key});

  @override
  State<SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<SearchViewBody> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// When near the bottom, attempt to load more stores.
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<StoresCubit>();
      final currentState = cubit.state;
      if (currentState is StoresSuccess &&
          !currentState.isLoadingMore &&
          currentState.pagination.hasNextPage) {
        cubit.loadNextPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Category tab bar.
        SliverToBoxAdapter(child: CategoryTabBar(
          onTabSelected: (categoryId) {
            log("Category selected: $categoryId");
            // Update the list by setting the new category filter.
            context.read<StoresCubit>().updateFilters(categoryId: categoryId);
          },
        )),
        // Store list.
        BlocBuilder<StoresCubit, StoresState>(
          builder: (context, state) {
            if (state is StoresFailure) {
              return SliverToBoxAdapter(
                  child: buildCustomErrorScreen(
                      context: context,
                      onRetry: () {
                        context.read<StoresCubit>().loadStores(isRefresh: true);
                        context
                            .read<CategoriesCubit>()
                            .fetchCategories(isRefresh: true);
                      }));
            }
            if (state is StoresLoading) {
              // Show skeleton placeholders during initial loading.
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildStoreCard(isLoading: true),
                  childCount: 8,
                ),
              );
            }
            if (state is StoresSuccess) {
              final stores = state.stores;
              // If loading more, add a few extra skeleton placeholders.
              final int placeholdersCount = state.isLoadingMore ? 5 : 0;
              final int totalItemCount = stores.length + placeholdersCount;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < stores.length) {
                      return _buildStoreCard(
                        isLoading: false,
                        store: stores[index],
                      );
                    }
                    return _buildStoreCard(isLoading: true);
                  },
                  childCount: totalItemCount,
                ),
              );
            }
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          },
        ),
      ],
    );
  }

  /// Builds a store card with a skeleton effect if loading.
  Widget _buildStoreCard({
    required bool isLoading,
    StoreEntity? store,
  }) {
    final imagePath = isLoading
        ? AppImages.assetsImagesTest2
        : AppImages
            .assetsImagesTest2; // Replace with store?.imageUrl if available.
    final title = isLoading ? '' : (store?.title ?? '');
    final subtitle = isLoading
        ? ''
        : 'Coupons: ${store?.totalCoupons ?? 0} • Savings: ${store?.averageSavings ?? 0}';
    return Skeletonizer(
      enabled: isLoading,
      child: GenericCard(
        imagePath: imagePath,
        title: title,
        subtitle: subtitle,
        onTap: () {
          if (!isLoading && store != null) {
            // For example, navigate to store details.
          }
        },
      ),
    );
  }
}
