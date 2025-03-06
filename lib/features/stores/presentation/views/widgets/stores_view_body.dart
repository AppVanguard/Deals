import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/widgets/generic_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StoresViewBody extends StatefulWidget {
  const StoresViewBody({Key? key}) : super(key: key);

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

  // Local boolean to control skeleton placeholders
  bool localIsLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize localIsLoading based on the current cubit state
    final currentState = context.read<StoresCubit>().state;
    localIsLoading = currentState is StoresLoading;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load more if near bottom
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
    return BlocListener<StoresCubit, StoresState>(
      listener: (context, state) {
        if (state is StoresLoading) {
          setState(() {
            localIsLoading = true;
          });
        } else {
          // In either success or failure, we consider loading done
          setState(() {
            localIsLoading = false;
          });
        }
      },
      child: DefaultTabController(
        length: tabs.length,
        child: Column(
          children: [
            // TabBar for categories.
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

            // If you want pull-to-refresh, wrap TabBarView in a RefreshIndicator:
            // Expanded(
            //   child: RefreshIndicator(
            //     onRefresh: () async {
            //       // Force a refresh
            //       context.read<StoresCubit>().fetchStores(isRefresh: true);
            //     },
            //     child: TabBarView(
            //       children: tabs.map((_) => _buildTabContent()).toList(),
            //     ),
            //   ),
            // ),

            // Without pull-to-refresh:
            Expanded(
              child: TabBarView(
                children: tabs.map((_) => _buildTabContent()).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return BlocBuilder<StoresCubit, StoresState>(
      builder: (context, state) {
        // 1) Show error
        if (state is StoresFailure) {
          return Center(child: Text(state.message));
        }

        // 2) If localIsLoading => show skeleton placeholders
        if (localIsLoading) {
          // Show, for example, 8 skeleton placeholders
          return ListView.builder(
            controller: _scrollController,
            itemCount: 8,
            itemBuilder: (context, index) {
              return storeSkeletonCard();
            },
          );
        }

        // 3) If success, show real data
        if (state is StoresSuccess) {
          final stores = state.stores;
          return ListView.builder(
            controller: _scrollController,
            itemCount: stores.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              // If we still have more data, show a "Loading..." at the bottom
              if (index >= stores.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return _buildStoreCard(stores[index]);
            },
          );
        }

        // If none of the above matched, might be the initial or a corner case
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStoreCard(StoreEntity store) {
    // For the "real" card, no skeleton needed, so pass enabled: false
    return Skeletonizer(
      enabled: false,
      child: GenericCard(
        imagePath: store.imageUrl ?? AppImages.assetsImagesTest2,
        title: store.title,
        subtitle: 'Coupons: ${store.totalCoupons ?? 0} '
            '• Savings: ${store.averageSavings ?? 0}',
        onTap: () {
          // Handle tap if needed
        },
      ),
    );
  }

  // When localIsLoading is true, we show these placeholders
  Widget storeSkeletonCard() {
    return Skeletonizer(
      enabled: true,
      child: GenericCard(
        imagePath: AppImages.assetsImagesTest2, // blank or placeholder
        title: '',
        subtitle: '',
        onTap: () {},
      ),
    );
  }
}
