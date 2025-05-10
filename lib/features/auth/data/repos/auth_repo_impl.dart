import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:deals/core/errors/exception.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/core/mappers/user_mapper.dart';
import 'package:deals/core/utils/backend_endpoints.dart';

import 'package:deals/core/service/auth_api_service.dart';
import 'package:deals/core/service/firebase_auth_service.dart';

import 'package:deals/core/models/user_model/user_model.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/generated/l10n.dart';

import 'package:deals/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  AuthRepoImpl({
    required this.firebaseAuthService,
    required this.authApiService,
  });

  // ─── Services ────────────────────────────────────────────────────────────
  final FirebaseAuthService firebaseAuthService;
  final AuthApiService authApiService;

  // ─── Registration ────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final data = await authApiService.registerUser(
        email: email,
        name: name,
        phone: phone,
        password: password,
      );
      log('createUserWithEmailAndPassword → $data');
      final entity = UserEntity(
        id: '',
        token: '',
        uId: data[BackendEndpoints.kFirbaseUid],
        fullName: name,
        email: data[BackendEndpoints.keyEmail] ?? email,
        phone: phone,
      );

      return right(entity);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('createUserWithEmailAndPassword EXCEPTION → $e');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  // ─── EMAIL / PASSWORD LOGIN ──────────────────────────────────────────────
  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final firebaseUser = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseToken = await firebaseUser.getIdToken();
      log('Firebase ID token (email/password): $firebaseToken');

      final UserModel userModel =
          await authApiService.sendOAuthToken(token: firebaseToken!);
      log('Backend JWT token: ${userModel.token}');

      return right(UserMapper.mapToEntity(userModel));
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('signInWithEmailAndPassword EXCEPTION → $e');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  // ─── GOOGLE LOGIN ────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final firebaseUser = await firebaseAuthService.signInWithGoogle();
      final firebaseToken = await firebaseUser.getIdToken();
      log('Firebase ID token (Google): $firebaseToken');

      final UserModel userModel =
          await authApiService.sendOAuthToken(token: firebaseToken!);
      log('Backend JWT token: ${userModel.token}');

      return right(UserMapper.mapToEntity(userModel));
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('signInWithGoogle EXCEPTION → $e');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  // ─── FACEBOOK LOGIN ──────────────────────────────────────────────────────
  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    try {
      final firebaseUser = await firebaseAuthService.signInWithFacebook();
      final firebaseToken = await firebaseUser.getIdToken();
      log('Firebase ID token (Facebook): $firebaseToken');

      final UserModel userModel =
          await authApiService.sendOAuthToken(token: firebaseToken!);
      log('Backend JWT token: ${userModel.token}');

      return right(UserMapper.mapToEntity(userModel));
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('signInWithFacebook EXCEPTION → $e');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  // ─── APPLE LOGIN ─────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    try {
      final firebaseUser = await firebaseAuthService.signInWithApple();
      final firebaseToken = await firebaseUser.getIdToken();
      log('Firebase ID token (Apple): $firebaseToken');

      final UserModel userModel =
          await authApiService.sendOAuthToken(token: firebaseToken!);
      log('Backend JWT token: ${userModel.token}');

      return right(UserMapper.mapToEntity(userModel));
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('signInWithApple EXCEPTION → $e');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  // ─── OTP HELPERS ─────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, UserEntity>> sendOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final entity = await authApiService.sendOtp(email: email, otp: otp);
      return right(entity);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('sendOtp EXCEPTION → $e');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final msg = await authApiService.verifyOtp(email: email, otp: otp);
      return right(msg);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('verifyOtp EXCEPTION → $e');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, Unit>> resendOtp({required String email}) async {
    try {
      await authApiService.resendOtp(email: email);
      return right(unit);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('resendOtp EXCEPTION → $e');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  // ─── PASSWORD RESET / CHANGE ─────────────────────────────────────────────
  @override
  Future<Either<Failure, String>> forgotPassword(
      {required String email}) async {
    try {
      final msg = await authApiService.forgotPassword(email: email);
      return right(msg);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('forgotPassword EXCEPTION → $e');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final msg = await authApiService.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      return right(msg);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('resetPassword EXCEPTION → $e');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  // ─── LOGOUT ──────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, Unit>> logout({required String firebaseUid}) async {
    try {
      await authApiService.logout(firebaseUid: firebaseUid);
      return right(unit);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('logout EXCEPTION → $e');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }
}
