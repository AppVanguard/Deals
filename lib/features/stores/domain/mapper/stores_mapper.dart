import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/mappers/category_mapper.dart';
import 'package:deals/features/stores/data/models/stores_model/data.dart';
import 'package:deals/features/stores/data/models/stores_model/stores_model.dart';

class StoresMapper {
  static List<StoreEntity> mapToEntities(StoresModel model) {
    return model.data == null
        ? []
        : model.data!.map((storeModel) => mapToEntity(storeModel)).toList();
  }

  static StoreEntity mapToEntity(Data storeModel) {
    return StoreEntity(
      category: CategoryMapper.mapToEntity(storeModel.category!),
      id: storeModel.id ?? '',
      title: storeModel.title ?? '',
      storeUrl: storeModel.storeUrl ?? '',
      imageUrl: storeModel.image?.url,
      isActive: storeModel.isActive ?? false,
      activeCoupons: storeModel.activeCoupons,
      averageSavings: storeModel.averageSavings,
      totalCoupons: storeModel.totalCoupons,
      popularityScore: storeModel.popularityScore,
    );
  }
}
