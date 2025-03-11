import 'dart:async';
import 'dart:developer';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/stores/presentation/views/widgets/filter_dialog.dart';
import 'package:deals/core/widgets/filter_dialog/filter_option.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

AppBar buildSearchAppBar(
  BuildContext context,
  TextEditingController searchController, {
  Timer? debounce,
}) {
  void onSearchChanged(String query) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 400), () {
      // Update the search filter.
      context.read<StoresCubit>().updateFilters(search: query);
    });
  }

  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    title: Row(
      children: [
        Expanded(
          child: SearchBar(
            backgroundColor: WidgetStateProperty.all(AppColors.lightGray),
            leading: SvgPicture.asset(
              AppImages.assetsImagesSearchIcon,
              width: 24,
              height: 24,
            ),
            elevation: WidgetStateProperty.all(0),
            controller: searchController,
            hintText: S.of(context).Search,
            onChanged: onSearchChanged,
            onSubmitted: onSearchChanged,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            final storesCubit = context.read<StoresCubit>();
            showDialog(
              context: context,
              builder: (c) => FilterDialog(
                onApplyFilter: (selectedFilter) {
                  log(selectedFilter.label);
                  // Update filters with the selected sort order, for example.
                  storesCubit.updateFilters(
                    sortOrder: selectedFilter.value,
                  );
                },
              ),
            );
          },
          child: SvgPicture.asset(
            AppImages.assetsImagesFilter,
            width: 24,
            height: 24,
          ),
        ),
      ],
    ),
  );
}
