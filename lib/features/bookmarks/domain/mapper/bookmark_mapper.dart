import 'package:deals/features/bookmarks/data/bookmark_model/bookmark_data.dart';
import 'package:deals/features/bookmarks/data/bookmark_model/bookmark_model.dart';
import 'package:deals/features/bookmarks/domain/entity/bookmark_entity.dart';

class BookmarksMapper {
  /// Convert the entire response model into a list of domain entities.
  static List<BookmarkEntity> mapToEntities(BookmarkModel model) {
    return model.data == null
        ? []
        : model.data!.map((bookmark) => mapToEntity(bookmark)).toList();
  }

  /// Convert a single BookmarkData into the domain BookmarkEntity.
  static BookmarkEntity mapToEntity(BookmarkData data) {
    final store = data.store;
    return BookmarkEntity(
      id: data.id ?? '',
      userId: data.user,
      firebaseUid: data.firebaseUid,
      storeId: store?.id ?? '',
      storeTitle: store?.title,
      storeImageUrl: store?.image?.url,
      storeTotalCoupons: store?.totalCoupons,
      storeCashbackRate: store?.cashback?.rate,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}
