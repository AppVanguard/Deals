import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:in_pocket/core/errors/exception.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/core/service/auth_api_service.dart';
import 'package:in_pocket/core/service/database_service.dart';
import 'package:in_pocket/core/service/firebase_auth_service.dart';
import 'package:in_pocket/features/auth/data/models/user_model.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';
import 'package:in_pocket/generated/l10n.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService backendStoreService;
  final AuthApiService authApiService;

  AuthRepoImpl({
    required this.firebaseAuthService,
    required this.backendStoreService,
    required this.authApiService,
  });

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    User? user;
    try {
      // Create user with Firebase.
      user = await firebaseAuthService.createUserWithEmailAndPassword(
        password: password,
        email: email,
      );

      // Update the display name if provided.
      if (name.isNotEmpty) {
        await user.updateDisplayName(name);
      }

      // Construct the UserEntity.
      final userEntity = UserEntity(
        uId: user.uid,
        email: email,
        name: name,
        phone: phone,
      );

      // --- Call the Auth API to register the user and send OTP ---
      await authApiService.registerUser(
        uid: user.uid,
        email: email,
        name: name,
        phone: phone,
        password: password,
      );
      await authApiService.sendOtp(email: email);

      // --- Persist user data to the backend database ---
      final userMap = UserModel.fromEntity(userEntity).toMap();
      await backendStoreService.addData(
        path: 'users',
        documentId: user.uid,
        data: userMap,
      );

      return right(userEntity);
    } on CustomExeption catch (e) {
      await deleteUser(user);
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      await deleteUser(user);
      log('Error in createUserWithEmailAndPassword: ${e.toString()}');
      return left(
          ServerFaliure(message: 'حدث خطأ ما يرجى المحاولة مرة أخرى لاحقا!'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in using Firebase.
      final user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userEntity = UserEntity(
        uId: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        phone: '',
      );

      // --- Send the OAuth token to the backend ---
      final token = await user.getIdToken();
      await authApiService.sendOAuthToken(token: token!);

      return right(userEntity);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('Error in signInWithEmailAndPassword: ${e.toString()}');
      return left(
          ServerFaliure(message: 'حدث خطأ ما يرجى المحاولة مرة أخرى لاحقا!'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithGoogle();
      final userEntity = UserEntity(
        uId: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        phone: '',
      );

      // --- Send the OAuth token ---
      final token = await user.getIdToken();
      await authApiService.sendOAuthToken(token: token!);

      return right(userEntity);
    } on CustomExeption catch (e) {
      await deleteUser(user);
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      await deleteUser(user);
      log('Error in signInWithGoogle: ${e.toString()}');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithFacebook();
      final userEntity = UserEntity(
        uId: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        phone: '',
      );

      // --- Send the OAuth token ---
      final token = await user.getIdToken();
      await authApiService.sendOAuthToken(token: token!);

      return right(userEntity);
    } on CustomExeption catch (e) {
      await deleteUser(user);
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      await deleteUser(user);
      log('Error in signInWithFacebook: ${e.toString()}');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithApple();
      final userEntity = UserEntity(
        uId: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        phone: '',
      );

      // --- Send the OAuth token ---
      final token = await user.getIdToken();
      await authApiService.sendOAuthToken(token: token!);

      return right(userEntity);
    } on CustomExeption catch (e) {
      await deleteUser(user);
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      await deleteUser(user);
      log('Error in signInWithApple: ${e.toString()}');
      return left(
          ServerFaliure(message: 'حدث خطأ ما يرجى المحاولة مرة أخرى لاحقا!'));
    }
  }

  /// Helper method to delete a partially created Firebase user if an error occurs.
  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }

  /// --- Additional backend data operations ---

  @override
  Future<void> addUserData({required UserEntity user}) async {
    try {
      final userMap = UserModel.fromEntity(user).toMap();
      await backendStoreService.addData(
        path: 'users',
        documentId: user.uId,
        data: userMap,
      );
    } catch (e) {
      log('Error in addUserData: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<UserEntity> getUserData({required String uid}) async {
    try {
      final data = await backendStoreService.getData(
        path: 'users',
        documentId: uid,
      );
      return UserModel.fromJson(data);
    } catch (e) {
      log('Error in getUserData: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> saveUserData({required UserEntity user}) async {
    try {
      final userMap = UserModel.fromEntity(user).toMap();
      await backendStoreService.updateData(
        path: 'users',
        documentId: user.uId,
        data: userMap,
      );
    } catch (e) {
      log('Error in saveUserData: ${e.toString()}');
      rethrow;
    }
  }
}
