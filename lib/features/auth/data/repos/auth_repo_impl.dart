import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_pocket/constants.dart';
import 'package:in_pocket/core/errors/exception.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/core/service/database_service.dart';
import 'package:in_pocket/core/service/firebase_auth_service.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';
import 'package:in_pocket/generated/l10n.dart';

/// An implementation of [AuthRepo] that handles:
/// 1. Creating users via Email/Password.
/// 2. Signing in users with multiple providers (Google, Facebook, Apple).
class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;

  AuthRepoImpl({
    required this.firebaseAuthService,
    required DatabaseService databaseService,
  });

  /// Create a new user with email & password.
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

      // Optionally update the displayName in FirebaseAuth.
      if (name.isNotEmpty) {
        await user.updateDisplayName(name);
      }

      // Construct user entity
      var userEntity = UserEntity(
        uId: user.uid,
        email: email,
        name: name,
        phone: phone,
      );

      return right(userEntity);
    } on CustomExeption catch (e) {
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

  /// Sign in an existing user with email & password.
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

      var userEntity = UserEntity(
        uId: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        phone: '',
      );

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

  /// Sign in with Google OAuth.
  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithGoogle();
      var userEntity = UserEntity(
        uId: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        phone: '',
      );

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

  /// Sign in with Facebook OAuth.
  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithFacebook();
      var userEntity = UserEntity(
        uId: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        phone: '',
      );

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

  /// Sign in with Apple OAuth.
  @override
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithApple();
      var userEntity = UserEntity(
        uId: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        phone: '',
      );

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

  /// Helper method to delete a partially created user if an exception occurs.
  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }

  @override
  Future<void> addUserData({required UserEntity user}) {
    // TODO: implement addUserData
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getUserData({required String uid}) {
    // TODO: implement getUserData
    throw UnimplementedError();
  }

  @override
  Future<void> saveUserData({required UserEntity user}) {
    // TODO: implement saveUserData
    throw UnimplementedError();
  }
}
