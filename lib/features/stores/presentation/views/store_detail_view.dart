import 'dart:developer';
import 'package:deals/features/stores/presentation/views/widgets/build_store_details_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'widgets/activated_bar.dart';
import 'widgets/cashback_tab_sliver.dart';
import 'widgets/coupons_tab_sliver.dart';
import 'widgets/about_tab_sliver.dart';
import 'widgets/pinned_tab_bar_header_delegate.dart';
import 'widgets/shop_now_bar.dart';

import 'package:deals/features/stores/presentation/manager/cubits/store_details_cubit/store_details_cubit.dart';
import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/entities/coupon_entity.dart';

class StoreDetailView extends StatefulWidget {
  const StoreDetailView({super.key, required this.storeId});

  final String storeId;
  static const routeName = '/store-detail';

  @override
  State<StoreDetailView> createState() => _StoreDetailViewState();
}

class _StoreDetailViewState extends State<StoreDetailView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  /// Controls whether the activated bar is showing.
  bool _isCashbackActivated = false;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _scrollController.addListener(_handleScroll);

    // Initialize the animation controller for sliding the activated bar
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom (off-screen)
      end: Offset.zero, // End at position (0,0) (fully visible)
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  void _handleScroll() {
    // For pagination in the Coupons tab.
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
    _slideController.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreDetailCubit, StoreDetailsState>(
      builder: (context, state) {
        // Trigger initial fetch.
        if (state is StoreDetailsInitial) {
          context.read<StoreDetailCubit>().getStoreAndCoupons(widget.storeId);
        }

        // Show error screen if needed.
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

        // Extract data.
        final isLoading =
            state is StoreDetailsInitial || state is StoreDetailsLoading;
        final storeEntity = state is StoreDetailsSuccess ? state.store : null;
        final coupons =
            state is StoreDetailsSuccess ? state.coupons : <CouponEntity>[];
        final isLoadingMore =
            state is StoreDetailsSuccess ? state.isLoadingMore : false;
        final hasNextPage =
            state is StoreDetailsSuccess ? state.pagination.hasNextPage : false;

        return Skeletonizer(
          enabled: isLoading,
          child: Scaffold(
            appBar: buildStoreDetailsAppBar(state),

            // Use a Stack to overlay the bottom bars.
            body: Stack(
              children: [
                // Main content.
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: AspectRatio(
                        aspectRatio: 1.4,
                        child: Image.asset(
                          AppImages.assetsImagesTest1,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
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

                // When activated, add a full-screen transparent GestureDetector.
                if (_isCashbackActivated)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        // Tapping outside the ActivatedBar dismisses it.
                        setState(() => _isCashbackActivated = false);
                        _slideController.reverse(); // Slide down the bar
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),

                // Always show the ShopNowBar at the bottom.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ShopNowBar(
                    discountValue: storeEntity?.cashBackRate.toString(),
                    onPressed: () {
                      // When pressed, show the ActivatedBar.
                      setState(() => _isCashbackActivated = true);
                      _slideController.forward(); // Slide up the bar
                    },
                  ),
                ),

                // Overlay the ActivatedBar.
                // It slides in from bottom (offset from (0, 1) to Offset.zero)
                // and slides out (back to Offset(0, 1)) when dismissed.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ActivatedBar(
                      storeTittle: storeEntity?.title,
                      discountValue: storeEntity?.cashBackRate.toString(),
                      onPressed: () {
                        // Button in the ActivatedBar can also dismiss it.
                        setState(() => _isCashbackActivated = false);
                        _slideController.reverse(); // Slide down the bar
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
