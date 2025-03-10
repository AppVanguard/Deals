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

  @override
  void initState() {
    super.initState();
    
    // Optionally trigger initial load if not already done by a parent/provider.
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
      // Update the search filter; this will refresh the list.
      context.read<StoresCubit>().updateFilters(search: query);
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
      body: const StoresViewBody(),
    );
  }
}
