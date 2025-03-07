import 'dart:async';
import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/core/repos/interface/categories_repo.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/features/search/presentation/views/widgets/build_search_app_bar.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/features/search/presentation/views/widgets/search_view_body.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  static const String routeName = 'search';

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

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
      context.read<StoresCubit>().fetchStores(isRefresh: true, search: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StoresCubit(
            storesRepo: getIt<StoresRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => CategoriesCubit(
            categoriesRepo: getIt<CategoriesRepo>(),
          ),
        ),
      ],
      // Wrap with Builder so that the context is below the providers.
      child: Builder(
        builder: (context) => Scaffold(
          appBar: buildSearchAppBar(
            context,
            searchController,
            debounce: _debounce,
          ),
          body: const SearchViewBody(),
        ),
      ),
    );
  }
}
