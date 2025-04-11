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
          activeImage: AppImages.assetsImagesHomeActive,
          inActiveImage: AppImages.assetsImagesHomeInActive,
          name: S.current.Home),
      BottomNavicationBarEntity(
          activeImage: AppImages.assetsImagesStoreActive,
          inActiveImage: AppImages.assetsImagesStoreInActive,
          name: S.current.Stores),
      BottomNavicationBarEntity(
          activeImage: AppImages.assetsImagesCouponActive,
          inActiveImage: AppImages.assetsImagesCouponInActive,
          name: S.current.Copouns),
      BottomNavicationBarEntity(
          activeImage: AppImages.assetsImagesBookmarkActive,
          inActiveImage: AppImages.assetsImagesBookmarkInActive,
          name: S.current.Bookmarks),
    ];
