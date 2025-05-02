import 'package:deals/features/personal_data/data/models/personal_model.dart';
import 'package:deals/features/personal_data/domain/entities/personal_entity.dart';

class PersonalMapper {
  /// Converts a [PersonalModel] into a fully non-nullable [PersonalEntity]
  /// (throws if any required field is missing).
  static PersonalEntity mapToEntity(PersonalModel m) {
    // 1. Enforce required fields
    if (m.id == null) throw ArgumentError('PersonalModel.id is null');
    if (m.firebaseUid == null) {
      throw ArgumentError('PersonalModel.firebaseUid is null');
    }
    if (m.fullName == null) {
      throw ArgumentError('PersonalModel.fullName is null');
    }
    if (m.email == null) throw ArgumentError('PersonalModel.email is null');

    // 2. Parse dateOfBirth if present
    DateTime? dob;
    if (m.dataOfBirth != null) {
      dob = m.dataOfBirth is DateTime
          ? m.dataOfBirth as DateTime
          : DateTime.parse(m.dataOfBirth.toString());
    }

    return PersonalEntity(
      // required
      id: m.id!,
      uId: m.firebaseUid!,
      fullName: m.fullName!,
      email: m.email!,

      // optional
      profileImageUrl: m.profileImage?.url,
      dateOfBirth: dob,
      gender: m.gender?.toString(),
      country: m.country?.toString(),
      city: m.city?.toString(),
      totalSavings: m.totalSavings ?? 0,
      favoriteStores: m.favoriteStores ?? [],
      bookmarks: m.bookmarks ?? [],
      isActive: m.isActive ?? false,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
    );
  }
}
