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

  /// If the user scrolls near the bottom, attempt to load more stores
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<StoresCubit>();
      final currentState = cubit.state;
      if (currentState is StoresSuccess && currentState.hasMore) {
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
          // The top TabBar for categories
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

          // The TabBarView below
          Expanded(
            child: TabBarView(
              children: tabs.map((_) => _buildTabContent()).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Renders content for each tab, based on the Cubit's StoresState.
  Widget _buildTabContent() {
    return BlocBuilder<StoresCubit, StoresState>(
      builder: (context, state) {
        // 1) If failure => show error
        if (state is StoresFailure) {
          return Center(child: Text(state.message));
        }

        // 2) If loading => show full skeleton placeholders
        //    (this happens on initial load or any "full" refresh)
        if (state is StoresLoading) {
          // e.g., show 8 skeleton cards
          return ListView.builder(
            controller: _scrollController,
            itemCount: 8,
            itemBuilder: (_, __) => _buildStoreCard(isLoading: true),
          );
        }

        // 3) If success => show existing items plus optional placeholders
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
                // Skeleton placeholders for partial load
                return _buildStoreCard(isLoading: true);
              }
            },
          );
        }

        // 4) If it's still StoresInitial or any corner case => show nothing
        return const SizedBox.shrink();
      },
    );
  }

  /// Single method that toggles skeleton vs. real card based on isLoading.
  Widget _buildStoreCard({
    required bool isLoading,
    StoreEntity? store,
  }) {
    // For skeleton cards, use empty placeholders
    final image =
        isLoading ? AppImages.assetsImagesTest2 : (AppImages.assetsImagesTest2);

    final title = isLoading ? '' : (store?.title ?? '');
    final subtitle = isLoading
        ? ''
        : 'Coupons: ${store?.totalCoupons ?? 0} • Savings: ${store?.averageSavings ?? 0}';

    return Skeletonizer(
      enabled: isLoading,
      child: GenericCard(
        imagePath: image,
        title: title,
        subtitle: subtitle,
        onTap: () {
          if (!isLoading && store != null) {
            // You might navigate to store details or do something else
          }
        },
      ),
    );
  }
}
