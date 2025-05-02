import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/models/user_model/user_model.dart';

class UserMapper {
  /// Converts a [UserModel] (all nullable) into a [UserEntity]
  /// (enforcing non-null id, uId, fullName & email).
  static UserEntity mapToEntity(UserModel m) {
    if (m.id == null) throw ArgumentError('id is null');
    if (m.firebaseUid == null) throw ArgumentError('firebaseUid is null');
    if (m.fullName == null) throw ArgumentError('fullName is null');
    if (m.email == null) throw ArgumentError('email is null');

    return UserEntity(
      // required
      id: m.id!,
      uId: m.firebaseUid!,
      fullName: m.fullName!,
      email: m.email!,

      // optional
      phone: m.phone ?? '',
      profileImageUrl: m.profileImage?.url,
      dateOfBirth: m.dataOfBirth is DateTime
          ? m.dataOfBirth as DateTime
          : (m.dataOfBirth != null
              ? DateTime.parse(m.dataOfBirth.toString())
              : null),
      gender: m.gender?.toString(),
      country: m.country?.toString(),
      city: m.city?.toString(),
      totalSavings: m.totalSavings ?? 0,
      favoriteStores: m.favoriteStores ?? [],
      bookmarks: m.bookmarks ?? [],
      isActive: m.isActive,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
      token: m.token ?? '',
    );
  }
}
