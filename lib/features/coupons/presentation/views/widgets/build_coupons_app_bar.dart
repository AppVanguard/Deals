import 'dart:developer';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/widgets/filter_dialog/filter_option.dart';
import 'package:deals/features/coupons/presentation/views/widgets/filter_dialog.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

AppBar buildCouponsAppBar(
  BuildContext context,
  TextEditingController searchController, {
  required Function(String) onSearchChanged,
  required Function(String, String) onFilterChanged,
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
                onApplyFilter: (selectedOrder, selectedFilter) {
                  log("selectedOrder: ${selectedOrder.value}");
                  log("selectedFilter: ${selectedFilter.value}");
                  // Notify parent with the chosen sort order and discount type.
                  onFilterChanged(
                    selectedOrder.value,
                    selectedFilter.value,
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
