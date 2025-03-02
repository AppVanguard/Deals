import 'package:deals/core/utils/app_images.dart';
import 'package:deals/generated/l10n.dart';

class BottomNavicationBarEntity {
  final String activeImage, inActiveImage, name;

  BottomNavicationBarEntity(
      {required this.activeImage,
      required this.inActiveImage,
      required this.name});
}

List<BottomNavicationBarEntity> get bottomNavigationBarList => [
      BottomNavicationBarEntity(
          activeImage: AppImages.assetsImagesIconsHomeActive,
          inActiveImage: AppImages.assetsImagesIconsHomeInActive,
          name: S.current.Home),
      BottomNavicationBarEntity(
          activeImage: AppImages.assetsImagesIconsCategoriesActive,
          inActiveImage: AppImages.assetsImagesIconsCategoriesInActive,
          name: S.current.Categories),
      BottomNavicationBarEntity(
          activeImage: AppImages.assetsImagesIconsCouponActive,
          inActiveImage: AppImages.assetsImagesIconsCouponInActive,
          name: S.current.Copouns),
      BottomNavicationBarEntity(
          activeImage: AppImages.assetsImagesIconsBookmarkActive,
          inActiveImage: AppImages.assetsImagesIconsBookmarkInActive,
          name: S.current.Bookmarks),
    ];
