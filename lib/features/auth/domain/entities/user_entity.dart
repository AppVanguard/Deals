/// A pure data model (Entity) representing the user in the domain layer.
class UserEntity {
  /// The user's unique Firebase Auth UID.
  final String uId;

  /// The user's email address.
  final String email;

  /// The user's display name.
  final String name;

  /// The user's phone number.
  final String phone;

  UserEntity({
    required this.uId,
    required this.email,
    required this.name,
    required this.phone,
  });
}
