import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/widgets/filter_dialog/filter_dialog.dart';
import 'package:deals/core/widgets/filter_dialog/filter_option.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

AppBar buildSearchAppBar(
    BuildContext context, TextEditingController searchController) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    ),
    title: Row(
      children: [
        Expanded(
          child: SearchBar(
            backgroundColor: WidgetStateProperty.all(AppColors.lightGray),
            leading: SvgPicture.asset(
              AppImages.assetsImagesIconsSearchIcon,
              width: 24,
              height: 24,
            ),
            elevation: const WidgetStatePropertyAll(0),
            controller: searchController,
            hintText: S.of(context).Search,
            onChanged: (query) {
              // TODO: Add search logic later.
            },
            onSubmitted: (query) {
              // TODO: Add search logic later.
            },
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => FilterDialog(
                onApplyFilter: (selectedFilter) {},
              ),
            );
          },
          child: SvgPicture.asset(
            AppImages.assetsImagesIconsFilter,
            width: 24,
            height: 24,
          ),
        ),
      ],
    ),
  );
}
