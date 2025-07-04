import 'dart:async';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:deals/features/stores/presentation/views/widgets/build_stores_app_bar.dart';
import 'package:deals/features/stores/presentation/views/widgets/stores_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/features/search/presentation/manager/search_cubit/search_cubit.dart';

class StoresView extends StatefulWidget {
  const StoresView({super.key});
  static const routeName = '/stores';

  @override
  State<StoresView> createState() => _StoresViewState();
}

class _StoresViewState extends State<StoresView> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  // Holds the currently selected category id (empty means "All")
  String _selectedCategoryId = '';
  // Holds the applied sort order from the filter dialog.
  String _selectedSortOrder = '';

  @override
  void initState() {
    super.initState();
    // Optionally trigger an initial load if needed
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
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<SearchCubit>().updateQuery(query);
      context.read<StoresCubit>().updateFilters(
        search: query,
        categoryId: _selectedCategoryId,
        sortOrder: _selectedSortOrder,
      );
    });
  }

  // Callback when a new category is chosen from the body.
  void _onCategoryChanged(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    context.read<StoresCubit>().updateFilters(
      search: context.read<SearchCubit>().state.query,
      categoryId: _selectedCategoryId,
      sortOrder: _selectedSortOrder,
    );
  }

  // Callback when new filter options (sort order) are applied from the app bar.
  void _onFilterChanged(String sortOrder) {
    setState(() {
      _selectedSortOrder = sortOrder;
    });
    context.read<StoresCubit>().updateFilters(
      search: context.read<SearchCubit>().state.query,
      categoryId: _selectedCategoryId,
      sortOrder: _selectedSortOrder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, searchState) {
        return Scaffold(
          appBar: buildStoresAppBar(
            context,
            searchController,
            onSearchChanged: _onSearchChanged,
            onFilterChanged: _onFilterChanged,
          ),
          body: StoresViewBody(
            selectedCategoryId: _selectedCategoryId,
            currentSearchQuery: searchState.query,
            selectedSortOrder: _selectedSortOrder,
            onCategoryChanged: _onCategoryChanged,
          ),
        );
      },
    );
  }
}
