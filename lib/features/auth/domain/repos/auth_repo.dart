import 'package:dartz/dartz.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';

/// Interface defining authentication operations for your app.
abstract class AuthRepo {
  /// Creates a user with Email & Password, and saves their data to Firestore.
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  });

  /// Signs in with Email & Password, returning user data from Firestore.
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs in with Google; creates a record in Firestore if user doesn't exist.
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Signs in with Facebook; creates a record in Firestore if user doesn't exist.
  Future<Either<Failure, UserEntity>> signInWithFacebook();

  /// Signs in with Apple; creates a record in Firestore if user doesn't exist.
  Future<Either<Failure, UserEntity>> signInWithApple();
  Future<Either<Failure, UserEntity>> sendOtp(
      {required String email, required String otp});

  // /// Adds a new user document to Firestore.
  // Future<void> addUserData({required UserEntity user});

  // /// Saves user data locally (e.g., in SharedPreferences).
  // Future<void> saveUserData({required UserEntity user});

  // /// Fetches user data from Firestore given a UID.
  // Future<UserEntity> getUserData({required String uid});
}
