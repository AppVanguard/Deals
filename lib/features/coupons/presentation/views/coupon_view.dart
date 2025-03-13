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

  // New state variables to hold the current search query and selected category.
  String _selectedCategory = '';
  String _searchQuery = '';

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
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    // Update the search query in state.
    setState(() {
      _searchQuery = query;
    });
    _debounce = Timer(const Duration(milliseconds: 400), () {
      // When the search changes, update filters with both search and category.
      context.read<CouponsCubit>().updateFilters(
            search: query,
            category: _selectedCategory,
          );
    });
  }

  // Callback for when the category is changed via the CouponViewBody.
  void _onCategoryChanged(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
    });
    // Update filters including any current search query.
    context.read<CouponsCubit>().updateFilters(
          search: _searchQuery,
          category: categoryId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCouponsAppBar(
        context,
        searchController,
        onSearchChanged: _onSearchChanged,
      ),
      // Pass both the current search query and selected category to the body.
      body: CouponViewBody(
        selectedCategory: _selectedCategory,
        currentSearchQuery: _searchQuery,
        onCategoryChanged: _onCategoryChanged,
      ),
    );
  }
}
