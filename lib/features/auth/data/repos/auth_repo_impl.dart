import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_pocket/core/errors/exception.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/core/service/auth_api_service.dart';
import 'package:in_pocket/core/service/firebase_auth_service.dart';
import 'package:in_pocket/core/utils/backend_endpoints.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';
import 'package:in_pocket/generated/l10n.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  // final DatabaseService backendStoreService;
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
      // Call the Auth API to register the user.
      final userResponse = await authApiService.registerUser(
        email: email,
        name: name,
        phone: phone,
        password: password,
      );
      final userEntity = UserEntity(
        uId: userResponse[
            BackendEndpoints.keyUserId], // e.g., "userId" from response
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
      log('$email $password');

      // Sign in using Firebase.
      // final user = await firebaseAuthService.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );

      // // --- Send the OAuth token to the backend ---
      // final token = await user.getIdToken();
      // log(token!);
      // await authApiService.sendOAuthToken(token: token!);
      await authApiService.loginUser(email: email, password: password);
      final userEntity = UserEntity(
        uId: '',
        email: '',
        name: '',
        phone: '',
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
      final userEntity = UserEntity(
        uId: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        phone: '',
      );

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
      return left(ServerFaliure(message: S.current.SomethingWentWrong));
    }
  }

  /// Helper method to delete a partially created Firebase user if an error occurs.
  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }

  @override
  Future<Either<Failure, UserEntity>> sendOtp({
    required String email,
    required String otp,
  }) async {
    try {
      // Call the API service to send OTP and capture the response.
      final response = await authApiService.sendOtp(email: email, otp: otp);

      // Parse the response into a UserEntity.
      final userEntity = UserEntity(
        uId: response.uId,
        email: response.email,
        name: response.name,
        phone: response.phone,
      );

      return right(userEntity);
    } on Exception catch (e) {
      return left(ServerFaliure(message: S.current.OtpVerfiedFailed));
    }
  }

  //
}
