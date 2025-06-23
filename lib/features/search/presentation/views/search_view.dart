import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/core/repos/interface/categories_repo.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:deals/features/stores/presentation/views/stores_view.dart';
import 'package:deals/features/search/presentation/manager/search_cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  static const String routeName = '/search';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StoresCubit(storesRepo: getIt<StoresRepo>()),
        ),
        BlocProvider(
          create: (context) =>
              CategoriesCubit(categoriesRepo: getIt<CategoriesRepo>()),
        ),
        BlocProvider(create: (_) => SearchCubit()),
      ],
      child: Builder(builder: (context) => const StoresView()),
    );
  }
}
