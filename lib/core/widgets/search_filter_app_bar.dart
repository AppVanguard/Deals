import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_colors.dart';
import '../utils/app_images.dart';

/// App bar with a search field and filter icon.
///
/// [controller] manages the search text.
/// [hintText] displayed inside the search field.
/// [onSearchChanged] invoked when the query changes or is submitted.
/// [onFilterTap] is called when the filter icon is tapped.
/// [filterIcon] optionally overrides the default filter icon widget.
class SearchFilterAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback onFilterTap;
  final Widget? filterIcon;

  const SearchFilterAppBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onSearchChanged,
    required this.onFilterTap,
    this.filterIcon,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.background,
      title: Row(
        children: [
          Expanded(
            child: SearchBar(
              controller: controller,
              hintText: hintText,
              leading: SvgPicture.asset(AppImages.assetsImagesSearchIcon),
              onChanged: onSearchChanged,
              onSubmitted: onSearchChanged,
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(AppColors.lightGray),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onFilterTap,
            child: filterIcon ??
                SvgPicture.asset(
                  AppImages.assetsImagesFilter,
                  width: 24,
                  height: 24,
                ),
          ),
        ],
      ),
    );
  }
}
