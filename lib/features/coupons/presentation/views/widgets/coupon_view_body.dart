import 'dart:developer';
import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/core/widgets/category_tab_bar.dart';
import 'package:deals/features/coupons/presentation/manager/cubits/coupons_cubit/coupons_cubit.dart';
import 'package:deals/features/coupons/presentation/views/coupon_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'coupons_coupon_ticket.dart';

class CouponViewBody extends StatefulWidget {
  final String selectedCategory;
  final String currentSearchQuery;
  final ValueChanged<String> onCategoryChanged;
  const CouponViewBody({
    super.key,
    required this.selectedCategory,
    required this.currentSearchQuery,
    required this.onCategoryChanged,
  });

  @override
  State<CouponViewBody> createState() => _CouponViewBodyState();
}

class _CouponViewBodyState extends State<CouponViewBody> {
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

  void _onScroll() {
    final cubit = context.read<CouponsCubit>();
    final currentState = cubit.state;
    if (currentState is CouponsSuccess &&
        !currentState.isLoadingMore &&
        currentState.pagination.hasNextPage &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      log("Fetching next page of coupons");
      cubit.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Category tab bar – simply notify parent on tap.
        SliverToBoxAdapter(
          child: CategoryTabBar(
            onTabSelected: (categoryId) => widget.onCategoryChanged(categoryId),
          ),
        ),
        BlocBuilder<CouponsCubit, CouponsState>(
          builder: (context, state) {
            if (state is CouponsLoading) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildCouponCard(isLoading: true),
                  childCount: 8,
                ),
              );
            } else if (state is CouponsSuccess) {
              final coupons = state.coupons;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // The first item is a header.
                    if (index == 0) {
                      return const SizedBox();
                    }
                    final couponIndex = index - 1;
                    if (couponIndex < coupons.length) {
                      return _buildCouponCard(
                        isLoading: false,
                        coupon: coupons[couponIndex],
                      );
                    } else if (state.pagination.hasNextPage) {
                      return _buildCouponCard(isLoading: true);
                    }
                    return Container();
                  },
                  childCount: coupons.length +
                      1 +
                      (state.pagination.hasNextPage ? 1 : 0),
                ),
              );
            } else if (state is CouponsFailure) {
              if (state.message.contains('Invalid token')) {
                return const SliverFillRemaining(child: SizedBox());
              }
              return SliverFillRemaining(
                child: buildCustomErrorScreen(
                  context: context,
                  onRetry: () {
                    context.read<CouponsCubit>().loadCoupons(isRefresh: true);
                    context
                        .read<CategoriesCubit>()
                        .fetchCategories(isRefresh: true);
                  },
                  errorMessage: state.message,
                ),
              );
            } else {
              return const SliverToBoxAdapter(
                child: Center(child: Text('No coupons found')),
              );
            }
          },
        )
      ],
    );
  }

  Widget _buildCouponCard({
    required bool isLoading,
    CouponEntity? coupon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Skeletonizer(
        enabled: isLoading,
        child: _buildCouponTicket(context, coupon, isLoading),
      ),
    );
  }

  Widget _buildCouponTicket(
      BuildContext context, CouponEntity? coupon, bool isLoading) {
    // If coupon is null => placeholder
    if (coupon == null) {
      return Skeletonizer(
        enabled: isLoading,
        child: CouponsCouponTicket(
          active: false,
          title: 'Loading...',
          width: MediaQuery.of(context).size.width * 0.8,
          height: 150,
          onPressed: () {},
        ),
      );
    } else {
      // If you have real fields, cast and pass them here
      // final c = coupon as CouponEntity;
      return Skeletonizer(
        enabled: isLoading,
        child: CouponsCouponTicket(
          active: coupon.active!,
          title: coupon.title,
          discountValue: coupon.discountValue,
          imageUrl: coupon.image,
          expiryDate: coupon.expiryDate,
          width: MediaQuery.of(context).size.width * 0.8,
          height: 150,
          onPressed: () {
            context.pushNamed(
              CouponDetailsView.routeName,
              extra: coupon.id,
            );
          },
        ),
      );
    }
  }
}
