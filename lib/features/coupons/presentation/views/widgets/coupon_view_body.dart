import 'dart:developer';

import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/widgets/category_tab_bar.dart';
import 'package:deals/core/widgets/coupon_ticket/coupon_ticket.dart';
import 'package:deals/features/coupons/presentation/manager/cubits/coupons_cubit/coupons_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

  bool isLoading = false;
  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<CouponsCubit>();
      final currentState = cubit.state;
      if (currentState is CouponsSuccess &&
          currentState.pagination.hasNextPage) {
        cubit.fetchCouppons();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        const SliverToBoxAdapter(
          child: CategoryTabBar(),
        ),
        BlocBuilder<CouponsCubit, CouponsState>(builder: (context, state) {
          log(state.toString());

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
                (context, index) => _buildCouponCard(
                  isLoading: false,
                  coupon: coupons[index],
                ),
                childCount: coupons.length,
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
        })
      ],
    );
  }

  Widget _buildCouponCard({
    required bool isLoading,
    CouponEntity? coupon,
  }) {
    return CouponTicket(
      coupon: coupon ??
          const CouponEntity(
            id: '',
            code: '',
            title: '',
            isActive: false,
          ),
      isLoading: isLoading,
    );
  }
}
