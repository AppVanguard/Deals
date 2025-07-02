import 'package:deals/core/utils/logger.dart';

import 'package:dartz/dartz.dart';

import 'package:deals/core/errors/exception.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/core/mappers/user_mapper.dart';
import 'package:deals/core/utils/backend_endpoints.dart';

import 'package:deals/core/service/auth_api_service.dart';
import 'package:deals/core/service/firebase_auth_service.dart';

import 'package:deals/core/models/user_model/user_model.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/generated/l10n.dart';

import 'package:deals/features/auth/domain/repos/auth_repo.dart';
import 'package:deals/core/repos/repo_helper.dart';

class AuthRepoImpl extends AuthRepo with RepoHelper {
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
      appLog('createUserWithEmailAndPassword → $data');
      final entity = UserEntity(
        id: '',
        token: '',
        uId: data[BackendEndpoints.kFirbaseUid],
        fullName: name,
        email: data[BackendEndpoints.keyEmail] ?? email,
        phone: phone,
      );

      return right(entity);
    } on CustomException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      appLog('createUserWithEmailAndPassword EXCEPTION → $e');
      return left(ServerFailure(message: S.current.SomethingWentWrong));
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
      appLog('Firebase ID token (email/password): $firebaseToken');

      final UserModel userModel =
          await authApiService.sendOAuthToken(token: firebaseToken!);
      appLog('Backend JWT token: ${userModel.token}');

      return right(UserMapper.mapToEntity(userModel));
    } on CustomException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      appLog('signInWithEmailAndPassword EXCEPTION → $e');
      return left(ServerFailure(message: S.current.SomethingWentWrong));
    }
  }

  // ─── GOOGLE LOGIN ────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final firebaseUser = await firebaseAuthService.signInWithGoogle();
      final firebaseToken = await firebaseUser.getIdToken();
      appLog('Firebase ID token (Google): $firebaseToken');

      final UserModel userModel =
          await authApiService.sendOAuthToken(token: firebaseToken!);
      appLog('Backend JWT token: ${userModel.token}');

      return right(UserMapper.mapToEntity(userModel));
    } on CustomException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      appLog('signInWithGoogle EXCEPTION → $e');
      return left(ServerFailure(message: S.current.SomethingWentWrong));
    }
  }

  // ─── FACEBOOK LOGIN ──────────────────────────────────────────────────────
  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    try {
      final firebaseUser = await firebaseAuthService.signInWithFacebook();
      final firebaseToken = await firebaseUser.getIdToken();
      appLog('Firebase ID token (Facebook): $firebaseToken');

      final UserModel userModel =
          await authApiService.sendOAuthToken(token: firebaseToken!);
      appLog('Backend JWT token: ${userModel.token}');

      return right(UserMapper.mapToEntity(userModel));
    } on CustomException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      appLog('signInWithFacebook EXCEPTION → $e');
      return left(ServerFailure(message: S.current.SomethingWentWrong));
    }
  }

  // ─── APPLE LOGIN ─────────────────────────────────────────────────────────
  @override

  // ─── OTP HELPERS ─────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, UserEntity>> sendOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final entity = await authApiService.sendOtp(email: email, otp: otp);
      return right(entity);
    } on CustomException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      appLog('sendOtp EXCEPTION → $e');
      return left(ServerFailure(message: S.current.SomethingWentWrong));
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
    } on CustomException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      appLog('verifyOtp EXCEPTION → $e');
      return left(ServerFailure(message: S.current.SomethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, Unit>> resendOtp({required String email}) async {
    try {
      await authApiService.resendOtp(email: email);
      return right(unit);
    } on CustomException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      appLog('resendOtp EXCEPTION → $e');
      return left(ServerFailure(message: S.current.SomethingWentWrong));
    }
  }

  // ─── PASSWORD RESET / CHANGE ─────────────────────────────────────────────
  @override
  Future<Either<Failure, String>> forgotPassword(
      {required String email}) async {
    try {
      final msg = await authApiService.forgotPassword(email: email);
      return right(msg);
    } on CustomException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      appLog('forgotPassword EXCEPTION → $e');
      return left(ServerFailure(message: S.current.SomethingWentWrong));
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
    } on CustomException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      appLog('resetPassword EXCEPTION → $e');
      return left(ServerFailure(message: S.current.SomethingWentWrong));
    }
  }

  // ─── LOGOUT ──────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, Unit>> logout({required String firebaseUid}) async {
    try {
      await authApiService.logout(firebaseUid: firebaseUid);
      return right(unit);
    } on CustomException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      appLog('logout EXCEPTION → $e');
      return left(ServerFailure(message: S.current.SomethingWentWrong));
    }
  }
}
