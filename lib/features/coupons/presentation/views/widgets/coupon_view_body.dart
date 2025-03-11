import 'dart:developer';
import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/category_tab_bar.dart';
import 'package:deals/core/widgets/coupon_ticket/coupon_ticket.dart';
import 'package:deals/features/coupons/presentation/manager/cubits/coupons_cubit/coupons_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CouponViewBody extends StatefulWidget {
  const CouponViewBody({super.key});

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
        SliverToBoxAdapter(
          child: CategoryTabBar(
            onTabSelected: (categoryId) {
              log("Category ID in the Body: $categoryId");
              // Update the list using the selected category.
              context.read<CouponsCubit>().updateFilters(category: categoryId);
            },
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
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Total Coupons: ${state.pagination.totalCoupons}',
                          style: AppTextStyles.bold14,
                        ),
                      );
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
              return SliverToBoxAdapter(
                child: Center(child: Text(state.message)),
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
      child: CouponTicket(
        tittle: coupon?.title,
        subTittle: 'Get',
        discountValue: coupon?.discountValue,
        image: coupon?.image,
        validTo: coupon?.expiryDate.toString(),
        isLoading: isLoading,
      ),
    );
  }
}
