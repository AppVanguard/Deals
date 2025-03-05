import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deals/core/errors/exception.dart';
import 'package:deals/core/errors/faliure.dart';
import 'package:deals/core/service/auth_api_service.dart';
import 'package:deals/core/service/firebase_auth_service.dart';
import 'package:deals/core/utils/backend_endpoints.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';
import 'package:deals/generated/l10n.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final AuthApiService authApiService;

  AuthRepoImpl({
    required this.firebaseAuthService,
    required this.authApiService,
  });

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final userResponse = await authApiService.registerUser(
        email: email,
        name: name,
        phone: phone,
        password: password,
      );
      final userEntity = UserEntity(
        token: '',
        uId: userResponse[BackendEndpoints.keyUserId],
        email: userResponse[BackendEndpoints.keyEmail] ?? email,
        name: name,
        phone: phone,
      );
      return right(userEntity);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('Error in createUserWithEmailAndPassword: ${e.toString()}');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      log('Attempting login for: $email');
      final user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final token = await user.getIdToken();
      log('Token: $token');
      final userResponse = await authApiService.sendOAuthToken(token: token!);
      final userEntity = UserEntity(
        token: token,
        uId: userResponse[BackendEndpoints.kFirbaseUid] ?? user.uid,
        email: userResponse[BackendEndpoints.keyEmail] ?? email,
        name: userResponse[BackendEndpoints.keyFullName] ??
            user.displayName ??
            '',
        phone: userResponse[BackendEndpoints.keyPhone] ?? '',
      );
      return right(userEntity);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('Error in signInWithEmailAndPassword: ${e.toString()}');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithGoogle();

      final token = await user.getIdToken();
      final userEntity = UserEntity(
        token: token!,
        uId: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        phone: '',
      );
      log('Token: $token');
      // final userResponse = await authApiService.sendOAuthToken(token: token!);
      // final userEntity = UserEntity(
      //   token: token,
      //   uId: userResponse[BackendEndpoints.kFirbaseUid] ?? user.uid,
      //   email: userResponse[BackendEndpoints.keyEmail] ?? user.email ?? '',
      //   name: userResponse[BackendEndpoints.keyFullName] ??
      //       user.displayName ??
      //       '',
      //   phone: userResponse[BackendEndpoints.keyPhone] ?? '',
      // );
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
      final token = await user.getIdToken();
      final userResponse = await authApiService.sendOAuthToken(token: token!);
      final userEntity = UserEntity(
        token: token,
        uId: userResponse[BackendEndpoints.kFirbaseUid] ?? user.uid,
        email: userResponse[BackendEndpoints.keyEmail] ?? user.email ?? '',
        name: userResponse[BackendEndpoints.keyFullName] ??
            user.displayName ??
            '',
        phone: userResponse[BackendEndpoints.keyPhone] ?? '',
      );
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
      final token = await user.getIdToken();
      final userResponse = await authApiService.sendOAuthToken(token: token!);
      final userEntity = UserEntity(
        token: token,
        uId: userResponse[BackendEndpoints.kFirbaseUid] ?? user.uid,
        email: userResponse[BackendEndpoints.keyEmail] ?? user.email ?? '',
        name: userResponse[BackendEndpoints.keyFullName] ??
            user.displayName ??
            '',
        phone: userResponse[BackendEndpoints.keyPhone] ?? '',
      );
      return right(userEntity);
    } on CustomExeption catch (e) {
      await deleteUser(user);
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      await deleteUser(user);
      log('Error in signInWithApple: ${e.toString()}');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> sendOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await authApiService.sendOtp(email: email, otp: otp);
      final userEntity = UserEntity(
        token: '',
        uId: response.uId,
        email: response.email,
        name: response.name,
        phone: response.phone,
      );
      return right(userEntity);
    } on Exception catch (e) {
      log('Error in sendOtp: ${e.toString()}');
      return left(ServerFaliure(message: S.current.OtpVerfiedFailed));
    }
  }

  @override
  Future<Either<Failure, Unit>> resendOtp({required String email}) async {
    try {
      final message = await authApiService.resendOtp(email: email);
      log('Resend OTP success: $message');
      return right(unit);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('Error in resendOtp: ${e.toString()}');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(
      {required String email}) async {
    try {
      final message = await authApiService.forgotPassword(email: email);
      log('Forgot password message: $message');
      return right(message);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('Error in forgotPassword: ${e.toString()}');
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
      final message = await authApiService.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      log('Reset password message: $message');
      return right(message);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('Error in resetPassword: ${e.toString()}');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout({required String firebaseUid}) async {
    try {
      await authApiService.logout(firebaseUid: firebaseUid);
      log('Logout completed successfully.');
      return right(unit);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('Error in logout: ${e.toString()}');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      log("in repo verifyOtp $otp, $email");
      final message = await authApiService.verifyOtp(email: email, otp: otp);
      return right(message);
    } on CustomExeption catch (e) {
      return left(ServerFaliure(message: e.message));
    } catch (e) {
      log('Error in verifyOtp: ${e.toString()}');
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }
}
