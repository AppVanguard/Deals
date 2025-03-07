import 'package:deals/core/entities/category_entity.dart';
import 'package:deals/core/models/category_model/category_model.dart';

class CategoryMapper {
  static CategoryEntity mapToEntity(CategoryModel categoryModel) {
    return CategoryEntity(
      id: categoryModel.data?.first.id ?? '',
      activeCouponCount: categoryModel.data?.first.activeCouponCount ?? 0,
      averageSavings: categoryModel.data?.first.averageSavings ?? 0,
      colorCode: categoryModel.data?.first.colorCode ?? '',
      createdAt: categoryModel.data?.first.createdAt,
      deletedAt: categoryModel.data?.first.deletedAt,
      isActive: categoryModel.data?.first.isActive ?? false,
      isFeatured: categoryModel.data?.first.isFeatured ?? false,
      order: categoryModel.data?.first.order ?? 0,
      slug: categoryModel.data?.first.slug ?? '',
      storeCount: categoryModel.data?.first.storeCount ?? 0,
      title: categoryModel.data?.first.title ?? '',
      updatedAt: categoryModel.data?.first.updatedAt,
    );
  }
}
