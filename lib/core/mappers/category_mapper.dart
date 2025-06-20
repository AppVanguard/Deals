import 'package:deals/core/entities/category_entity.dart';
import 'package:deals/core/models/category_model/category_data.dart';

class CategoryMapper {
  static CategoryEntity mapToEntity(CategoryData categoryData) {
    return CategoryEntity(
      id: categoryData.id ?? '',
      activeCouponCount: categoryData.activeCouponCount ?? 0,
      averageSavings: categoryData.averageSavings ?? 0,
      colorCode: categoryData.colorCode ?? '',
      createdAt: categoryData.createdAt,
      deletedAt: categoryData.deletedAt,
      isActive: categoryData.isActive ?? false,
      isFeatured: categoryData.isFeatured ?? false,
      order: categoryData.order ?? 0,
      slug: categoryData.slug ?? '',
      storeCount: categoryData.storeCount ?? 0,
      title: categoryData.title ?? '',
      updatedAt: categoryData.updatedAt,
    );
  }
}
