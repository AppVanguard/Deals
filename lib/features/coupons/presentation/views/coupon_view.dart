import 'dart:async';
import 'package:deals/features/coupons/presentation/manager/cubits/coupons_cubit/coupons_cubit.dart';
import 'package:deals/features/coupons/presentation/views/widgets/build_coupons_app_bar.dart';
import 'package:deals/features/coupons/presentation/views/widgets/coupon_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CouponView extends StatefulWidget {
  const CouponView({super.key});
  static const routeName = 'coupons';

  @override
  State<CouponView> createState() => _CouponViewState();
}

class _CouponViewState extends State<CouponView> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Optionally, trigger an initial load:
    // context.read<CouponsCubit>().loadCoupons(isRefresh: true);
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Debounce search: wait 400ms after user stops typing
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      // Update the search filter and refresh data.
      context.read<CouponsCubit>().updateFilters(search: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCouponsAppBar(
        context,
        searchController,
        onSearchChanged: _onSearchChanged,
      ),
      body: const CouponViewBody(),
    );
  }
}
