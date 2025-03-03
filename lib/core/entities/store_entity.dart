class StoreEntity {
  final String id;
  final String title;
  final String storeUrl;
  final String? imageUrl;
  final bool isActive;
  // Add whichever fields you actually use in your domain/UI

  const StoreEntity({
    required this.id,
    required this.title,
    required this.storeUrl,
    this.imageUrl,
    required this.isActive,
  });
}
