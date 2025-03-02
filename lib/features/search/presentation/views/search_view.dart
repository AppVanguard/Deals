// lib/features/search/presentation/views/search_view.dart

import 'package:deals/features/search/presentation/views/widgets/build_search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/search/presentation/views/widgets/deal.dart';
import 'package:deals/features/search/presentation/views/widgets/search_view_body.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  static const String routeName = 'search';

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchAppBar(context, _searchController),
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
        ],
      ),
    );
  }
}
