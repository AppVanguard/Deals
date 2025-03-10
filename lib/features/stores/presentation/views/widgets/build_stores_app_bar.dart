import 'dart:developer';

import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/stores/presentation/views/widgets/filter_dialog.dart';
import 'package:deals/features/stores/presentation/views/widgets/filter_option.dart';
import 'package:deals/features/stores/presentation/manager/cubits/stores_cubit/stores_cubit.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

AppBar buildStoresAppBar(
  BuildContext context,
  TextEditingController searchController, {
  required Function(String) onSearchChanged,
}) {
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
            showDialog(
              context: context,
              builder: (c) => FilterDialog(
                onApplyFilter: (selectedFilter) {
                  log(selectedFilter.value);
                  // Use the selectedFilter here when fetching stores.
                  context.read<StoresCubit>().fetchStores(
                        isRefresh: true,
                        // Pass the selectedFilter to your fetchStores method.
                        sortOrder: selectedFilter.value,
                        // You may also want to pass the order option if needed.
                        // sortOrder: yourSortOrderValue,
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
