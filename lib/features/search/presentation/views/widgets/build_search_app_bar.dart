import 'dart:async';
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

AppBar buildSearchAppBar(
  BuildContext context,
  TextEditingController searchController, {
  Timer? debounce,
}) {
  void onSearchChanged0(String query) {
    // Debounce search: wait 400ms after user stops typing
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<StoresCubit>().fetchStores(isRefresh: true, search: query);
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
            onChanged: onSearchChanged0,
            onSubmitted: onSearchChanged0,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // Capture the StoresCubit instance before opening the dialog.
            final storesCubit = context.read<StoresCubit>();
            showDialog(
              context: context,
              builder: (c) => FilterDialog(
                onApplyFilter: (selectedFilter) {
                  log(selectedFilter.label);
                  storesCubit.fetchStores(
                    isRefresh: true,
                    sortOrder: selectedFilter.label,
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
