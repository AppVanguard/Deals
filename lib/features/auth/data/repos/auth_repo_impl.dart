import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_pocket/constants.dart';
import 'package:in_pocket/core/errors/exception.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/core/service/database_service.dart';
import 'package:in_pocket/core/service/firebase_auth_service.dart';
import 'package:in_pocket/core/service/shared_prefrences_singleton.dart';
import 'package:in_pocket/core/utils/backend_endpoints.dart';
import 'package:in_pocket/features/auth/data/models/user_model.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';
import 'package:in_pocket/generated/l10n.dart';

/// An implementation of [AuthRepo] that handles:
/// 1. Creating users via Email/Password.
/// 2. Signing in users with multiple providers (Google, Facebook, Apple).
/// 3. Storing/fetching user data in Firestore.
/// 4. Saving user data locally (SharedPreferences).
class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService databaseService;

  AuthRepoImpl({
    required this.databaseService,
    required this.firebaseAuthService,
  });

  /// Create a new user with email & password, store [name] & [phone] in Firestore.
  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    User? user;
    try {
      // Create user with email & password via FirebaseAuth
      user = await firebaseAuthService.createUserWithEmailAndPassword(
        password: password,
        email: email,
      );

      // Optionally update the displayName in FirebaseAuth (not necessary for Firestore storage).
      if (user != null && name.isNotEmpty) {
        await user.updateDisplayName(name);
      }

      // Construct your entity (including phone)
      var userEntity = UserEntity(
        uId: user.uid,
        email: email,
        name: name,
        phone: phone,
      );

      // Store user doc in Firestore
      await addUserData(user: userEntity);

      // You may optionally store user data locally
      await saveUserData(user: userEntity);

      return right(userEntity);
    } on CustomExeption catch (e) {
      // If there's an issue, ensure you delete the partially created user
      await deleteUser(user);
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      await deleteUser(user);
      log('Error in createUserWithEmailAndPassword: ${e.toString()}');
      return left(
        ServerFaliure(message: 'حدث خطأ ما يرجى المحاولة مرة أخرى لاحقا!'),
      );
    }
  }

  /// Sign in an existing user with email & password, returning data from Firestore.
  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in the user
      var user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Retrieve user data from Firestore
      var userEntity = await getUserData(uid: user.uid);

      // Save user data locally
      await saveUserData(user: userEntity);

      return right(userEntity);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('Error in signInWithEmailAndPassword: ${e.toString()}');
      return left(
        ServerFaliure(message: 'حدث خطأ ما يرجى المحاولة مرة أخرى لاحقا!'),
      );
    }
  }

  /// Sign in with Google OAuth; store new user data if they don't exist in Firestore.
  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithGoogle();
      var userEntity = UserModel.fromFirebaseUser(user);
      await saveUserData(user: userEntity);

      var isUserExist = await databaseService.checkIfDataExists(
          path: BackendEndpoints.isUserExists, documentId: userEntity.uId);
      if (isUserExist) {
        await getUserData(uid: userEntity.uId);
      } else {
        await addUserData(user: userEntity);
      }
      return right(userEntity);
    } on CustomExeption catch (e) {
      await deleteUser(user);
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      await deleteUser(user);

      log('Error in FirebaseAuthService.signInWithGoogle: ${e.toString()}');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  /// Sign in with Facebook OAuth; store new user data if they don't exist in Firestore.
  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithFacebook();
      UserEntity userEntity = UserModel.fromFirebaseUser(user);

      var isUserExist = await databaseService.checkIfDataExists(
        path: BackendEndpoints.isUserExists,
        documentId: userEntity.uId,
      );

      if (!isUserExist) {
        await addUserData(user: userEntity);
      } else {
        userEntity = await getUserData(uid: userEntity.uId);
      }

      await saveUserData(user: userEntity);

      return right(userEntity);
    } on CustomExeption catch (e) {
      await deleteUser(user);
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      await deleteUser(user);
      log('Error in signInWithFacebook: ${e.toString()}');
      return left(
        ServerFaliure(message: S.current.SomethingWentWrong),
      );
    }
  }

  /// Sign in with Apple OAuth; store new user data if they don't exist in Firestore.
  @override
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithApple();
      UserEntity userEntity = UserModel.fromFirebaseUser(user);

      var isUserExist = await databaseService.checkIfDataExists(
        path: BackendEndpoints.isUserExists,
        documentId: userEntity.uId,
      );

      if (!isUserExist) {
        await addUserData(user: userEntity);
      } else {
        userEntity = await getUserData(uid: userEntity.uId);
      }

      await saveUserData(user: userEntity);

      return right(userEntity);
    } on CustomExeption catch (e) {
      await deleteUser(user);
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      await deleteUser(user);
      log('Error in signInWithApple: ${e.toString()}');
      return left(
        ServerFaliure(message: 'حدث خطأ ما يرجى المحاولة مرة أخرى لاحقا!'),
      );
    }
  }

  /// Create/Update a user document in Firestore with [user].
  @override
  Future<void> addUserData({required UserEntity user}) async {
    await databaseService.addData(
      path: BackendEndpoints.addUserData,
      data: UserModel.fromEntity(user).toMap(),
      documentId: user.uId,
    );
  }

  /// Helper method to delete a partially created user if an exception occurs.
  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }

  /// Fetch user data from Firestore for a given UID.
  @override
  Future<UserEntity> getUserData({required String uid}) async {
    var userData = await databaseService.getData(
      path: BackendEndpoints.getUserData,
      documentId: uid,
    );
    return UserModel.fromJson(userData);
  }

  /// Save user data locally (e.g., shared preferences).
  @override
  Future<void> saveUserData({required UserEntity user}) async {
    var jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
    await Prefs.setString(kUserData, jsonData);
  }
}
