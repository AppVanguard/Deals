import 'dart:developer';

import 'package:deals/core/entities/coupon_entity.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:deals/features/coupons/presentation/views/widgets/coupon_ticket.dart';
import 'package:deals/features/stores/presentation/manager/cubits/store_details_cubit/store_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CouponsTab extends StatefulWidget {
  final StoreEntity? storeEntity;
  final List<CouponEntity>? coupons;

  const CouponsTab({super.key, this.storeEntity, this.coupons});

  @override
  State<CouponsTab> createState() => _CouponsTabState();
}

class _CouponsTabState extends State<CouponsTab> {
  late final ScrollController _scrollController;
  final _scrollThreshold = 200.0;
  final _skeletonItemCount = 5;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    final cubit = context.read<StoreDetailCubit>();
    final state = cubit.state;

    if (state is StoreDetailsSuccess &&
        !state.isLoadingMore &&
        state.pagination.hasNextPage &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - _scrollThreshold) {
      log("Loading next page of coupons");
      cubit.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreDetailCubit, StoreDetailsState>(
      builder: (context, state) {
        return switch (state) {
          StoreDetailsInitial() ||
          StoreDetailsLoading() =>
            _buildLoadingState(),
          StoreDetailsSuccess() =>
            _buildSuccessState(state.coupons, state.pagination.hasNextPage),
          StoreDetailsFailure() => _buildErrorState(context),
          _ => _buildErrorState(context),
        };
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _skeletonItemCount,
      itemBuilder: (_, index) => const CouponItemSkeleton(),
    );
  }

  Widget _buildSuccessState(List<CouponEntity> coupons, bool hasNextPage) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: coupons.length + (hasNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= coupons.length) {
          return const CouponItemSkeleton();
        }
        return CouponItem(coupon: coupons[index]);
      },
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return buildCustomErrorScreen(
      context: context,
      onRetry: () => context
          .read<StoreDetailCubit>()
          .getStoreAndCoupons(widget.storeEntity?.id ?? ''),
    );
  }
}

class CouponItem extends StatelessWidget {
  final CouponEntity coupon;

  const CouponItem({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: CouponTicket(
        title: coupon.title,
        code: coupon.code,
        discountValue: coupon.discountValue,
        imageUrl: coupon.image,
        expiryDate: coupon.expiryDate,
        width: MediaQuery.of(context).size.width * 0.8,
        height: 150,
        onPressed: _handleCouponPress,
      ),
    );
  }

  void _handleCouponPress() {
    // Handle coupon press action
  }
}

class CouponItemSkeleton extends StatelessWidget {
  const CouponItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Skeletonizer(
        child: CouponTicket(
          title: 'Loading...',
          code: 'Loading...',
          width: MediaQuery.of(context).size.width * 0.8,
          height: 150,
          onPressed: () {},
        ),
      ),
    );
  }
}
