import 'dart:developer';
import 'package:deals/features/stores/presentation/views/widgets/about_tab_sliver.dart';
import 'package:deals/features/stores/presentation/views/widgets/build_store_details_app_bar.dart';
import 'package:deals/features/stores/presentation/views/widgets/cashback_tab_sliver.dart';
import 'package:deals/features/stores/presentation/views/widgets/coupons_tab.dart';
import 'package:deals/features/stores/presentation/views/widgets/pinned_tab_bar_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/stores/presentation/manager/cubits/store_details_cubit/store_details_cubit.dart';
import 'package:deals/core/entities/coupon_entity.dart';

import 'widgets/store_detail_bottom_bar.dart';

class StoreDetailView extends StatefulWidget {
  const StoreDetailView({
    super.key,
    required this.storeId,
  });

  final String storeId;
  static const routeName = '/store-detail';

  @override
  State<StoreDetailView> createState() => _StoreDetailViewState();
}

class _StoreDetailViewState extends State<StoreDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  /// Tracks whether the cashback has been activated
  bool _isCashbackActivated = false;

  @override
  void initState() {
    super.initState();
    // We have three tabs: Cashback, Coupons, About
    _tabController = TabController(length: 3, vsync: this);

    // Rebuild whenever user taps a different tab
    _tabController.addListener(() => setState(() {}));

    // For pagination in Coupons tab
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    // Only trigger pagination if the Coupons tab (index == 1) is active
    if (_tabController.index == 1) {
      final position = _scrollController.position;
      if (position.maxScrollExtent - position.pixels < 200.0) {
        final cubit = context.read<StoreDetailCubit>();
        final state = cubit.state;
        if (state is StoreDetailsSuccess &&
            !state.isLoadingMore &&
            state.pagination.hasNextPage) {
          log("Loading next page of coupons...");
          cubit.loadNextPage();
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreDetailCubit, StoreDetailsState>(
      builder: (context, state) {
        // If initial, fetch data
        if (state is StoreDetailsInitial) {
          context.read<StoreDetailCubit>().getStoreAndCoupons(widget.storeId);
        }

        // If error => error screen
        if (state is StoreDetailsFailure) {
          return buildCustomErrorScreen(
            context: context,
            onRetry: () {
              context
                  .read<StoreDetailCubit>()
                  .getStoreAndCoupons(widget.storeId);
            },
          );
        }

        // Extract data or fallback
        final isLoading =
            state is StoreDetailsInitial || state is StoreDetailsLoading;
        final storeEntity = state is StoreDetailsSuccess ? state.store : null;
        final coupons =
            state is StoreDetailsSuccess ? state.coupons : <CouponEntity>[];
        final hasNextPage =
            state is StoreDetailsSuccess ? state.pagination.hasNextPage : false;
        final isLoadingMore =
            state is StoreDetailsSuccess ? state.isLoadingMore : false;

        // Build UI with skeleton overlay if loading
        return Skeletonizer(
          enabled: isLoading,
          child: Scaffold(
            // Transparent AppBar from your separate widget builder
            appBar: buildStoreDetailsAppBar(state),

            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // 1) Big store image
                SliverToBoxAdapter(
                  child: AspectRatio(
                    aspectRatio: 1.4,
                    child: Image.asset(
                      AppImages.assetsImagesTest1,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                // 2) Pinned TabBar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: TabBarHeaderDelegate(
                    child: Container(
                      color: Colors.white,
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(text: "Cashback"),
                          Tab(text: "Coupons"),
                          Tab(text: "About"),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3) Show the selected tab's slivers
                if (_tabController.index == 0)
                  CashbackTabSliver(
                    storeEntity: storeEntity,
                    isLoading: isLoading,
                  ),

                if (_tabController.index == 1)
                  CouponsTabSliver(
                    storeEntity: storeEntity,
                    coupons: coupons,
                    isLoading: isLoading,
                    isLoadingMore: isLoadingMore,
                    hasNextPage: hasNextPage,
                  ),

                if (_tabController.index == 2)
                  AboutTabSliver(
                    storeEntity: storeEntity,
                    isLoading: isLoading,
                  ),
              ],
            ),

            // Bottom bar with AnimatedSwitcher logic
            bottomNavigationBar: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SizeTransition(sizeFactor: animation, child: child);
              },
              child: _isCashbackActivated
                  ? ActivatedBar(
                      key: const ValueKey('ActivatedBar'),
                      onPressed: () {
                        // TODO: handle "Continue to Alibaba"
                      },
                    )
                  : ShopNowBar(
                      key: const ValueKey('ShopNowBar'),
                      onPressed: () {
                        setState(() {
                          _isCashbackActivated = true;
                        });
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
