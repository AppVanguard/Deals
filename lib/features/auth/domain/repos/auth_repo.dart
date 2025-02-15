import 'package:dartz/dartz.dart';
import 'package:in_pocket/core/errors/faliure.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  });

  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, UserEntity>> signInWithFacebook();

  Future<Either<Failure, UserEntity>> signInWithApple();

  Future<Either<Failure, UserEntity>> sendOtp({
    required String email,
    required String otp,
  });

  Future<Either<Failure, Unit>> resendOtp({required String email});

  Future<Either<Failure, String>> forgotPassword({required String email});

  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<Either<Failure, Unit>> logout({required String firebaseUid});
}
