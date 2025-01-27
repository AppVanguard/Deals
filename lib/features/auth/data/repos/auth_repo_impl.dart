import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_pocket/constants.dart';
import 'package:in_pocket/core/errors/exception.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/core/service/database_service.dart';
import 'package:in_pocket/core/service/firebase_auth_service.dart';
import 'package:in_pocket/core/service/shared_prefrences_singleton%20copy.dart';
import 'package:in_pocket/core/utils/backend_endpoints.dart';
import 'package:in_pocket/features/auth/data/models/user_model.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService databaseService;
  AuthRepoImpl(
      {required this.databaseService, required this.firebaseAuthService});
  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String name}) async {
    User? user;
    try {
      user = await firebaseAuthService.createUserWithEmailAndPassword(
        password: password,
        email: email,
      );
      var userEntity = UserEntity(uId: user.uid, email: email, name: name);
      await addUserData(user: userEntity);
      return right(userEntity);
    } on CustomExeption catch (e) {
      await deleteUser(user);
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      deleteUser(user);
      log('Error in FirebaseAuthService.createUserWithEmailAndPassword: ${e.toString()}');
      return left(
          ServerFaliure(message: 'حدث خطأ ما يرجى المحاولة مرة أخرى لاحقا!'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      var user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userEntity = await getUserData(uid: user.uid);
      await saveUserData(user: userEntity);

      return right(userEntity);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('Error in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()}');
      return left(
          ServerFaliure(message: 'حدث خطأ ما يرجى المحاولة مرة أخرى لاحقا!'));
    }
  }

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
      return left(
          ServerFaliure(message: 'حدث خطأ ما يرجى المحاولة مرة أخرى لاحقا!'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithFacebook();
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

      log('Error in FirebaseAuthService.signInWithFacebook: ${e.toString()}');
      return left(
          ServerFaliure(message: 'حدث خطأ ما يرجى المحاولة مرة أخرى لاحقا!'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithApple();
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

      log('Error in FirebaseAuthService.signInWithApple: ${e.toString()}');
      return left(
          ServerFaliure(message: 'حدث خطأ ما يرجى المحاولة مرة أخرى لاحقا!'));
    }
  }

  @override
  Future addUserData({required UserEntity user}) async {
    await databaseService.addData(
      path: BackendEndpoints.addUserData,
      data: UserModel.fromEntity(user).toMap(),
      documentId: user.uId,
    );
  }

  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }

  @override
  Future<UserEntity> getUserData({required String uid}) async {
    var userData = await databaseService.getData(
        path: BackendEndpoints.getUserData, documentId: uid);
    return UserModel.fromJson(userData);
  }

  @override
  Future saveUserData({required UserEntity user}) async {
    var jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
    await Prefs.setString(kUserData, jsonData);
  }
}
