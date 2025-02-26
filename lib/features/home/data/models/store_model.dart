// store_model.dart
import 'package:in_pocket/features/home/domain/entities/store_entity.dart';

class StoreModel extends StoreEntity {
  const StoreModel({
    required String id,
    required String title,
    required String storeUrl,
    required String imageUrl,
  }) : super(
          id: id,
          title: title,
          storeUrl: storeUrl,
          imageUrl: imageUrl,
        );

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    // "image" key might be missing, or "url" might be missing. Default to empty string to avoid null issues.
    final imageData = json['image'] as Map<String, dynamic>?;
    return StoreModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      storeUrl: json['store_url'] ?? '',
      imageUrl: (imageData?['url'] as String?) ?? '',
    );
  }
}
