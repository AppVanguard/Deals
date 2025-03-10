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

  /// If near the bottom, attempt to load more stores.
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<StoresCubit>();
      final currentState = cubit.state;
      if (currentState is StoresSuccess &&
          currentState.pagination.hasNextPage) {
        cubit.fetchStores();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Category tab or widget placeholder
        SliverToBoxAdapter(
          child: CategoryTabBar(
            onTabSelected: (categoryId) {
              log("Category ID in the Body: $categoryId");
              // Call fetchStores with the selected categoryId.
              context
                  .read<StoresCubit>()
                  .fetchStores(categoryId: categoryId, isRefresh: true);
            },
          ),
        ),

        BlocBuilder<StoresCubit, StoresState>(
          builder: (context, state) {
            if (state is StoresFailure) {
              return SliverToBoxAdapter(
                child: Center(child: Text(state.message)),
              );
            }

            if (state is StoresLoading) {
              // Show skeleton placeholders for loading
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildStoreCard(isLoading: true),
                  childCount: 8,
                ),
              );
            }

            if (state is StoresSuccess) {
              final stores = state.stores;

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // The first item is a header showing the total number of stores.
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Total Stores: ${state.pagination.totalStores}',
                          style: AppTextStyles.bold14,
                        ),
                      );
                    }
                    // Adjust the index to account for the header.
                    final storeIndex = index - 1;
                    if (storeIndex < stores.length) {
                      return _buildStoreCard(
                        isLoading: false,
                        store: stores[storeIndex],
                      );
                    }
                    // If more pages are available, show a loading indicator.
                    if (state.pagination.hasNextPage) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return Container();
                  },
                  // Total count: header + stores + loading indicator (if needed)
                  childCount: stores.length +
                      1 +
                      (state.pagination.hasNextPage ? 1 : 0),
                ),
              );
            }

            // For StoresInitial and other states.
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          },
        ),
      ],
    );
  }

  /// Single method to build a store card with skeleton effect.
  Widget _buildStoreCard({
    required bool isLoading,
    StoreEntity? store,
  }) {
    final imagePath = isLoading
        ? AppImages.assetsImagesTest2
        : AppImages
            .assetsImagesTest2; // You can use store?.imageUrl if available

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
            // For example: navigate to store details
          }
        },
      ),
    );
  }
}
