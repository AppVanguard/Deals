import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'bookmark_filter_dialog.dart';

AppBar buildBookmarkAppBar(
  BuildContext context,
  TextEditingController controller, {
  required Function(String) onSearch,
  required Function(List<String>, String, bool, bool) onFilterChanged,
  required List<String> selectedCats,
  required String sortOrder,
  required bool hasCoupons,
  required bool hasCashback,
}) {
  return AppBar(
    elevation: 0,
    backgroundColor: AppColors.background,
    title: Row(
      children: [
        Expanded(
          child: SearchBar(
            controller: controller,
            hintText: S.of(context).Search,
            leading: SvgPicture.asset(AppImages.assetsImagesSearchIcon),
            onChanged: onSearch,
            onSubmitted: onSearch,
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(AppColors.lightGray),
          ),
        ),
        const SizedBox(width: 12),
        Builder(
          // ensure we’re below the cubits
          builder: (ctx) => GestureDetector(
            onTap: () {
              final catCubit = ctx.read<CategoriesCubit>();
              showDialog(
                context: ctx,
                builder: (_) => BlocProvider.value(
                  // pass existing cubit
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
            child: SvgPicture.asset(
              AppImages.assetsImagesFilter,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    ),
  );
}
