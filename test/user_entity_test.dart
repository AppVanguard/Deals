import 'package:deals/core/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserEntity JSON serialization', () {
    test('toJson and fromJson round-trip with all fields', () {
      final user = UserEntity(
        id: '1',
        token: 'token',
        uId: 'uid',
        fullName: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        profileImageUrl: 'https://example.com/image.png',
        dateOfBirth: DateTime(1990, 1, 1),
        gender: 'male',
        country: 'USA',
        city: 'New York',
        totalSavings: 10,
        favoriteStores: ['store1'],
        bookmarks: ['coupon1'],
        isActive: true,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      final json = user.toJson();
      final decoded = UserEntity.fromJson(json);

      expect(decoded.toJson(), json);
    });

    test('toJson and fromJson round-trip with null optional fields', () {
      final user = UserEntity(
        id: '2',
        token: 'token2',
        uId: 'uid2',
        fullName: 'Jane Doe',
        email: 'jane@example.com',
        phone: '0987654321',
      );

      final json = user.toJson();
      final decoded = UserEntity.fromJson(json);

      expect(decoded.toJson(), json);
      expect(decoded.profileImageUrl, isNull);
      expect(decoded.dateOfBirth, isNull);
      expect(decoded.gender, isNull);
      expect(decoded.country, isNull);
      expect(decoded.city, isNull);
      expect(decoded.totalSavings, 0);
      expect(decoded.favoriteStores, isEmpty);
      expect(decoded.bookmarks, isEmpty);
      expect(decoded.isActive, isNull);
      expect(decoded.createdAt, isNull);
      expect(decoded.updatedAt, isNull);
    });
  });
}
