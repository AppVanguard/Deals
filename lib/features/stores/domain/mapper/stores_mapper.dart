import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/features/stores/data/models/stores_data.dart';
import 'package:deals/features/stores/data/models/stores_model.dart';

class StoresMapper {
  static List<StoreEntity> mapToEntities(StoresModel model) {
    return model.data == null
        ? []
        : model.data!.map((storeModel) => mapToEntity(storeModel)).toList();
  }

  static StoreEntity mapToEntity(StoresData storeModel) {
    return StoreEntity(
      categoryId: storeModel.category?.id ?? '',
      terms: storeModel.cashback?.terms,
      id: storeModel.id ?? '',
      title: storeModel.title ?? '',
      storeUrl: storeModel.storeUrl ?? '',
      imageUrl: storeModel.image?.url,
      isActive: storeModel.isActive ?? false,
      activeCoupons: storeModel.activeCoupons,
      cashBackRate: storeModel.cashback?.rate ?? 0,
      totalCoupons: storeModel.totalCoupons,
      popularityScore: storeModel.popularityScore ?? 0,
      description: storeModel.description,
    );
  }
}
