import 'dart:developer';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/category_tab_bar.dart';
import 'package:deals/core/widgets/generic_card.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StoresViewBody extends StatefulWidget {
  const StoresViewBody({super.key});

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
              // Update the list by setting the new category filter.
              context.read<StoresCubit>().updateFilters(categoryId: categoryId);
            },
          ),
        ),
        // Main store list.
        BlocBuilder<StoresCubit, StoresState>(
          builder: (context, state) {
            if (state is StoresFailure) {
              return SliverToBoxAdapter(
                  child: Center(child: Text(state.message)));
            }
            if (state is StoresLoading) {
              // Display skeleton placeholders.
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
                    // Index 0 is a header.
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Total Stores: $totalStores',
                            style: AppTextStyles.bold14),
                      );
                    }
                    // Adjust index for the header.
                    final storeIndex = index - 1;
                    if (storeIndex < stores.length) {
                      final store = stores[storeIndex];
                      log("Building storeIndex $storeIndex => ${store.title}");
                      return _buildStoreCard(isLoading: false, store: store);
                    }
                    if (showLoadingIndicator) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return Container();
                  },
                  // Count: header + store items + possible loading indicator.
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
    final imagePath =
        isLoading ? AppImages.assetsImagesTest2 : AppImages.assetsImagesTest2;
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
            // Navigate to store details or perform an action.
          }
        },
      ),
    );
  }
}
