import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/search/presentation/views/widgets/filter_dialog.dart';
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
            leading: SvgPicture.asset(
              AppImages.assetsImagesIconsSearchIcon,
              width: 24,
              height: 24,
            ),
            elevation: const WidgetStatePropertyAll(0),
            controller: searchController,
            hintText: 'Search',
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
