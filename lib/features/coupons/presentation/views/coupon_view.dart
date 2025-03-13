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

  // State variables to hold the applied filters.
  String _selectedCategory = '';
  String _searchQuery = '';
  String _selectedSortOrder = '';
  String _selectedDiscountType = '';

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
    setState(() {
      _searchQuery = query;
    });
    _debounce = Timer(const Duration(milliseconds: 400), () {
      // Update filters with search, category and the chosen filter options.
      context.read<CouponsCubit>().updateFilters(
            search: _searchQuery,
            category: _selectedCategory,
            sortOrder: _selectedSortOrder,
            discountType: _selectedDiscountType,
          );
    });
  }

  // Callback for when a new category is chosen.
  void _onCategoryChanged(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
    });
    // Update filters including any current search and filter options.
    context.read<CouponsCubit>().updateFilters(
          search: _searchQuery,
          category: _selectedCategory,
          sortOrder: _selectedSortOrder,
          discountType: _selectedDiscountType,
        );
  }

  // Callback for when new filter options are applied from the dialog.
  void _onFilterChanged(String sortOrder, String discountType) {
    setState(() {
      _selectedSortOrder = sortOrder;
      _selectedDiscountType = discountType;
    });
    context.read<CouponsCubit>().updateFilters(
          search: _searchQuery,
          category: _selectedCategory,
          sortOrder: _selectedSortOrder,
          discountType: _selectedDiscountType,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCouponsAppBar(
        context,
        searchController,
        onSearchChanged: _onSearchChanged,
        onFilterChanged: _onFilterChanged,
      ),
      // Pass down the current search query and category,
      // and a callback to update the category.
      body: CouponViewBody(
        selectedCategory: _selectedCategory,
        currentSearchQuery: _searchQuery,
        onCategoryChanged: _onCategoryChanged,
      ),
    );
  }
}
