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
      cashBackRate: double.parse((storeModel.cashback?.rate).toString()),
      totalCoupons: storeModel.totalCoupons,
      popularityScore: double.parse((storeModel.popularityScore).toString()),
      description: storeModel.description,
    );
  }
}
