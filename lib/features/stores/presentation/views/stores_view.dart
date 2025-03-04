import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/stores/presentation/views/widgets/build_category_app_bar.dart';
import 'package:deals/features/stores/presentation/views/widgets/stores_view_body.dart';
import 'package:deals/features/stores/presentation/views/widgets/stores_deal.dart';
import 'package:flutter/material.dart';

class StoresView extends StatefulWidget {
  const StoresView({super.key});
  static const routeName = 'categories';

  @override
  State<StoresView> createState() => _StoresViewState();
}

class _StoresViewState extends State<StoresView> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildStoresAppBar(context, searchController),
      body: StoresViewBody(
        deals: [
          StoresDeal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest3,
          ),
          StoresDeal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest3,
          ),
          StoresDeal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest3,
          ),
          StoresDeal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest3,
          ),
          StoresDeal(
            title: 'Deal',
            subtitle: 'Subtitle',
            imagePath: AppImages.assetsImagesTest3,
          ),
        ],
      ),
    );
  }
}
