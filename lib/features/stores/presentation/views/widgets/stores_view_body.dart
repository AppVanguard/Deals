// stores_view_body.dart

import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/widgets/generic_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StoresViewBody extends StatefulWidget {
  const StoresViewBody({super.key});

  @override
  State<StoresViewBody> createState() => _StoresViewBodyState();
}

class _StoresViewBodyState extends State<StoresViewBody> {
  final ScrollController _scrollController = ScrollController();

  final List<String> tabs = [
    'All',
    'New stores',
    'Marketplace',
    'Fashion',
    'Food&Drink',
    'Travel',
  ];

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

  /// If near the bottom, attempt to load more
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<StoresCubit>();
      final currentState = cubit.state;

      // Instead of `currentState.hasMore`, we now check `currentState.pagination.hasNextPage`
      if (currentState is StoresSuccess &&
          currentState.pagination.hasNextPage) {
        // Fetch more
        cubit.fetchStores(isRefresh: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          // Tabs across the top
          Container(
            color: Colors.white,
            child: TabBar(
              isScrollable: true,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.green,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal),
              tabs: tabs.map((tabText) => Tab(text: tabText)).toList(),
            ),
          ),

          // TabBarView content below
          Expanded(
            child: TabBarView(
              children: tabs.map((_) => _buildTabContent()).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return BlocBuilder<StoresCubit, StoresState>(
      builder: (context, state) {
        // 1) If error
        if (state is StoresFailure) {
          return Center(child: Text(state.message));
        }

        // 2) If loading => show skeleton placeholders
        if (state is StoresLoading) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: 8,
            itemBuilder: (context, index) {
              return _buildStoreCard(isLoading: true);
            },
          );
        }

        // 3) If success => show real data, plus skeleton placeholders if isLoadingMore
        if (state is StoresSuccess) {
          final stores = state.stores;
          final placeholdersCount = state.isLoadingMore ? 5 : 0;
          final totalItemCount = stores.length + placeholdersCount;

          return ListView.builder(
            controller: _scrollController,
            itemCount: totalItemCount,
            itemBuilder: (context, index) {
              if (index < stores.length) {
                // Real store
                return _buildStoreCard(
                  isLoading: false,
                  store: stores[index],
                );
              } else {
                // Skeleton placeholder
                return _buildStoreCard(isLoading: true);
              }
            },
          );
        }

        // 4) Otherwise (StoresInitial, etc.) => nothing
        return const SizedBox.shrink();
      },
    );
  }

  /// Single method that toggles skeleton or real card
  Widget _buildStoreCard({
    required bool isLoading,
    StoreEntity? store,
  }) {
    final imagePath = isLoading
        ? AppImages.assetsImagesTest2
        : (AppImages.assetsImagesTest2); // or store?.imageUrl if available

    final title = isLoading ? '' : store?.title ?? '';
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
            // Navigate to store details or do something else
          }
        },
      ),
    );
  }
}
