import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deals/core/widgets/search_filter_app_bar.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'bookmark_filter_dialog.dart';

PreferredSizeWidget buildBookmarkAppBar(
  BuildContext context,
  TextEditingController controller, {
  required Function(String) onSearch,
  required Function(List<String>, String, bool, bool) onFilterChanged,
  required List<String> selectedCats,
  required String sortOrder,
  required bool hasCoupons,
  required bool hasCashback,
}) {
  return SearchFilterAppBar(
    controller: controller,
    hintText: S.of(context).Search,
    onSearchChanged: onSearch,
    onFilterTap: () {
      final catCubit = context.read<CategoriesCubit>();
      showDialog(
        context: context,
        builder: (_) => BlocProvider.value(
          value: catCubit,
          child: BookmarkFilterDialog(
            initialCategories: selectedCats,
            initialOrder: sortOrder,
            initialHasCoupons: hasCoupons,
            initialHasCashback: hasCashback,
            onApply: onFilterChanged,
          ),
        ),
      );
    },
  );
}
