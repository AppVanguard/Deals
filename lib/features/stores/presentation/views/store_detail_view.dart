import 'dart:developer';
import 'package:deals/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/features/stores/presentation/manager/cubits/store_details_cubit/store_details_cubit.dart';

import 'widgets/build_store_details_app_bar.dart';
import 'widgets/activated_bar.dart';
import 'widgets/cashback_tab_sliver.dart';
import 'widgets/coupons_tab_sliver.dart';
import 'widgets/about_tab_sliver.dart';
import 'widgets/pinned_tab_bar_header_delegate.dart';
import 'widgets/shop_now_bar.dart';

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

  /// Whether the ActivatedBar is currently visible
  bool _activatedBarVisible = false;

  /// Animation controller & tween for the ActivatedBar slide-in/out
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _scrollController.addListener(_handleScroll);

    // Setup the animation for the ActivatedBar
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start off-screen at bottom
      end: Offset.zero, // Slide fully into view
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _handleScroll() {
    // For pagination in the Coupons tab:
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

  /// Show the ActivatedBar with a forward slide animation
  void _openActivatedBar() {
    setState(() => _activatedBarVisible = true);
    _slideController.forward();
  }

  /// Reverse the slide animation, then remove the bar from the tree
  Future<void> _closeActivatedBar() async {
    await _slideController.reverse();
    if (mounted) {
      setState(() => _activatedBarVisible = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreDetailCubit, StoreDetailsState>(
      builder: (context, state) {
        // Trigger initial fetch if needed
        if (state is StoreDetailsInitial) {
          context.read<StoreDetailCubit>().getStoreAndCoupons(widget.storeId);
        }

        // Show error screen if there's a failure
        if (state is StoreDetailsFailure) {
          return buildCustomErrorScreen(
            context: context,
            onRetry: () {
              context
                  .read<StoreDetailCubit>()
                  .getStoreAndCoupons(widget.storeId);
            },
            errorMessage: state.message,
          );
        }

        // Extract data
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
            appBar: buildStoreDetailsAppBar(
              context,
              state,
            ),
            body: Stack(
              children: [
                // MAIN CONTENT: CustomScrollView for store details & coupons
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: AspectRatio(
                        aspectRatio: 1.4,
                        child: Image.network(
                          storeEntity?.imageUrl ?? '',
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: double.infinity,
                            height: 200,
                            color: AppColors.tertiaryText,
                          ),
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
                    // Slivers for each tab
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

                // The ShopNowBar pinned at bottom (behind the ActivatedBar).
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ShopNowBar(
                    discountValue: storeEntity?.cashBackRate?.toString(),
                    onPressed: _openActivatedBar,
                  ),
                ),

                // If the ActivatedBar is visible, we show it with the SlideTransition
                // and a transparent GestureDetector behind it (no dark overlay).
                if (_activatedBarVisible) ...[
                  // 1) Capture taps outside the bar to close it, but keep the background normal
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _closeActivatedBar,
                      // Transparent so we do NOT darken the background
                      child: Container(color: AppColors.background),
                    ),
                  ),
                  // 2) The ActivatedBar sliding up on top
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ActivatedBar(
                        imageUrl: storeEntity?.imageUrl,
                        discountValue: storeEntity?.cashBackRate?.toString(),
                        storeTittle: storeEntity?.title,
                        onPressed: _closeActivatedBar,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
