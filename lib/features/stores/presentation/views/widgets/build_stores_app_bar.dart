// build_category_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/search/presentation/views/widgets/filter_dialog.dart';
import 'package:deals/generated/l10n.dart';

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
              AppImages.assetsImagesIconsSearchIcon,
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
              builder: (_) => const FilterDialog(),
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
