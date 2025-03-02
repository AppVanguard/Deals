import 'package:deals/features/search/presentation/views/widgets/deal.dart';
import 'package:deals/features/search/presentation/views/widgets/search_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:deals/core/utils/app_images.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  static const String routeName = 'search';

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  // Using a basic TextEditingController for the SearchBar.
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent app bar background if desired.
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // A leading back button.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        // Replacing the SearchAnchor with the SearchBar widget.
        title: Row(
          children: [
            Expanded(
              child: SearchBar(
                leading: SvgPicture.asset(
                  AppImages.assetsImagesIconsSearchIcon,
                  width: 24,
                  height: 24,
                ),
                elevation: WidgetStatePropertyAll(0),
                controller: _searchController,
                hintText: 'Search',
                // These callbacks are placeholders for your logic.
                onChanged: (query) {
                  // TODO: Add search logic later.
                },
                onSubmitted: (query) {
                  // TODO: Add search logic later.
                },
                // You can add suggestions here if needed in the future.
                // suggestions: [],
              ),
            ),
            const SizedBox(width: 12),
            SvgPicture.asset(
              AppImages.assetsImagesIconsFilter,
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
      body: const SearchViewBody(
        deals: [
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
          Deal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest2,
          ),
        ],
      ),
    );
  }
}
