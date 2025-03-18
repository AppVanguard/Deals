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
  const CouponsTab({super.key, this.storeEntity, this.coupons});
  final StoreEntity? storeEntity;
  final List<CouponEntity>? coupons;

  @override
  State<CouponsTab> createState() => _CouponsTabState();
}

class _CouponsTabState extends State<CouponsTab> {
  late ScrollController controller;
  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_onScroll);
    controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<StoreDetailCubit>();
    final currentState = cubit.state;
    if (currentState is StoreDetailsSuccess &&
        !currentState.isLoadingMore &&
        currentState.pagination.hasNextPage &&
        controller.position.pixels >=
            controller.position.maxScrollExtent - 200) {
      log("Fetching next page of coupons");
      cubit.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreDetailCubit, StoreDetailsState>(
      builder: (context, state) {
        if (state is StoreDetailsFailure) {
          return buildCustomErrorScreen(context: context, onRetry: () {});
        }

        if (state is StoreDetailsInitial || state is StoreDetailsLoading) {
          return ListView.builder(
            controller: controller,
            itemBuilder: (context, index) => _buildCouponCard(isLoading: true),
            itemCount: 5,
          );
        } else if (state is StoreDetailsSuccess) {
          final coupons = state.coupons;
          final hasNextPage = state.pagination.hasNextPage;

          return ListView.builder(
            controller: controller,
            itemCount: 1 + coupons.length + (hasNextPage ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SizedBox(height: 8); // Adjust spacing as needed
              } else if (index - 1 < coupons.length) {
                return _buildCouponCard(
                  isLoading: false,
                  coupon: coupons[index - 1],
                );
              } else {
                // Loading indicator with skeletons
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    5,
                    (index) => _buildCouponCard(isLoading: true),
                  ),
                );
              }
            },
          );
        } else {
          return buildCustomErrorScreen(context: context, onRetry: () {});
        }
      },
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
        child: _buildCouponTicket(context, coupon),
      ),
    );
  }

  Widget _buildCouponTicket(BuildContext context, CouponEntity? coupon) {
    // If coupon is null => placeholder
    if (coupon == null) {
      return CouponTicket(
        title: 'Loading...',
        code: 'Loading...',
        width: MediaQuery.of(context).size.width * 0.8,
        height: 150,
        onPressed: () {},
      );
    } else {
      // If you have real fields, cast and pass them here
      // final c = coupon as CouponEntity;
      return CouponTicket(
        title: coupon.title,
        code: coupon.code,
        discountValue: coupon.discountValue,
        imageUrl: coupon.image,
        expiryDate: coupon.expiryDate,
        width: MediaQuery.of(context).size.width * 0.8,
        height: 150,
        onPressed: () {
          // handle click
        },
      );
    }
  }
}
