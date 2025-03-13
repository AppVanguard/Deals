import 'dart:async';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:deals/features/stores/presentation/views/widgets/build_stores_app_bar.dart';
import 'package:deals/features/stores/presentation/views/widgets/stores_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoresView extends StatefulWidget {
  const StoresView({super.key});
  static const routeName = 'stores';

  @override
  State<StoresView> createState() => _StoresViewState();
}

class _StoresViewState extends State<StoresView> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  // Holds the currently selected category id (empty means "All")
  String _selectedCategoryId = '';
  // Holds the current search query entered by the user
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Optionally trigger initial load if not already done.
    // context.read<StoresCubit>().loadStores(isRefresh: true);
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    // Update the current search query in state.
    setState(() {
      _searchQuery = query;
    });
    _debounce = Timer(const Duration(milliseconds: 400), () {
      // When the search changes, update filters with both query and category.
      context.read<StoresCubit>().updateFilters(
            search: query,
            categoryId: _selectedCategoryId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildStoresAppBar(
        context,
        searchController,
        onSearchChanged: _onSearchChanged,
      ),
      // Pass both the current selected category and search query to the child.
      body: StoresViewBody(
        selectedCategoryId: _selectedCategoryId,
        currentSearchQuery: _searchQuery,
        onCategoryChanged: (categoryId) {
          setState(() {
            _selectedCategoryId = categoryId;
          });
        },
      ),
    );
  }
}
