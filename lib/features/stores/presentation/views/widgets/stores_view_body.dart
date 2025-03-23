import 'dart:developer';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/core/widgets/category_tab_bar.dart';
import 'package:deals/core/widgets/generic_card.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:deals/features/stores/presentation/views/store_detail_view.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StoresViewBody extends StatefulWidget {
  final String selectedCategoryId;
  final String currentSearchQuery;
  // Also receive the current sort order (if needed for visual cues or debugging)
  final String selectedSortOrder;
  final ValueChanged<String> onCategoryChanged;
  const StoresViewBody({
    super.key,
    required this.selectedCategoryId,
    required this.currentSearchQuery,
    required this.selectedSortOrder,
    required this.onCategoryChanged,
  });

  @override
  State<StoresViewBody> createState() => _StoresViewBodyState();
}

class _StoresViewBodyState extends State<StoresViewBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// When near the bottom, load the next page.
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<StoresCubit>();
      final currentState = cubit.state;
      if (currentState is StoresSuccess && !currentState.isLoadingMore) {
        if (currentState.stores.length < currentState.pagination.totalStores!) {
          log("Scrolling => load next page");
          cubit.loadNextPage();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Category tab bar.
        SliverToBoxAdapter(
          child: CategoryTabBar(
            onTabSelected: (categoryId) {
              log("Category selected: $categoryId");
              // Notify the parent about the new category selection.
              widget.onCategoryChanged(categoryId);
              // Update the filters with the current search and sort order.
              context.read<StoresCubit>().updateFilters(
                    search: widget.currentSearchQuery,
                    categoryId: categoryId,
                    sortOrder: widget.selectedSortOrder,
                  );
            },
          ),
        ),
        // Main store list.
        BlocBuilder<StoresCubit, StoresState>(
          builder: (context, state) {
            if (state is StoresFailure) {
              return SliverFillRemaining(
                child: buildCustomErrorScreen(
                  context: context,
                  onRetry: () {
                    context.read<StoresCubit>().loadStores(isRefresh: true);
                    context
                        .read<CategoriesCubit>()
                        .fetchCategories(isRefresh: true);
                  },
                ),
              );
            }
            if (state is StoresLoading) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildStoreCard(isLoading: true),
                  childCount: 8,
                ),
              );
            }
            if (state is StoresSuccess) {
              final stores = state.stores;
              final totalStores = state.pagination.totalStores;
              final bool showLoadingIndicator = (stores.length < totalStores!);
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) {
                      return const SizedBox();
                    }
                    final storeIndex = index - 1;
                    if (storeIndex < stores.length) {
                      final store = stores[storeIndex];
                      log("Building storeIndex $storeIndex => ${store.title}");
                      return _buildStoreCard(isLoading: false, store: store);
                    }
                    if (showLoadingIndicator) {
                      return _buildStoreCard(isLoading: true);
                    }
                    return Container();
                  },
                  childCount: stores.length + 2,
                ),
              );
            }
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          },
        ),
      ],
    );
  }

  /// Helper to build a store card or a skeleton card while loading.
  Widget _buildStoreCard({
    required bool isLoading,
    StoreEntity? store,
  }) {
    final imagePath = store?.imageUrl;
    final title = isLoading ? 'unknown' : (store?.title ?? 'unknown');
    final subtitle = isLoading
        ? 'unknown'
        : store?.cashBackRate != 0 && store?.totalCoupons != 0
            ? "${S.of(context).upTo} ${store!.cashBackRate}% ${S.of(context).CashbackC} + ${store.totalCoupons} ${S.of(context).Coupons}"
            : store?.cashBackRate == 0 && store?.totalCoupons != 0
                ? "${store!.totalCoupons} ${S.of(context).Coupons}"
                : store?.cashBackRate != 0 && store?.totalCoupons == 0
                    ? "${S.of(context).upTo} ${store!.cashBackRate}% ${S.of(context).CashbackC}"
                    : 'No cashback or coupons';
    return Skeletonizer(
      enabled: isLoading,
      child: GenericCard(
        imagePath: imagePath ?? '',
        title: title,
        subtitle: subtitle,
        onTap: () {
          if (!isLoading && store != null) {
            context.pushNamed(
              StoreDetailView.routeName,
              extra: store.id,
            );
          }
        },
      ),
    );
  }
}
