import 'package:dartz/dartz.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';

/// Signature for methods that initiate a social sign in process.
typedef SignInCall = Future<Either<Failure, UserEntity>> Function();

/// Helper mixin to DRY up social sign in flows across cubits.
mixin SocialSigninHelper {
  /// Handles emitting loading, success and failure states for social sign in.
  ///
  /// [signInCall] should perform the social sign in and return an [Either]
  /// containing a [Failure] or the signed in [UserEntity].
  /// [rememberMe] controls persisting the `kRememberMe` preference. If
  /// [persistUser] is true the [UserEntity] is also stored using
  /// [SecureStorageService]. Any optional [afterSuccess] callback will be
  /// executed before [emitSuccess] is called.
  Future<void> handleSocialSignIn({
    required SignInCall signInCall,
    required bool rememberMe,
    required void Function() emitLoading,
    required void Function(String) emitFailure,
    required void Function(UserEntity) emitSuccess,
    bool persistUser = false,
    Future<void> Function(UserEntity)? afterSuccess,
  }) async {
    emitLoading();
    final result = await signInCall();
    await result.fold(
      (failure) async => emitFailure(failure.message),
      (user) async {
        Prefs.setBool(kRememberMe, rememberMe);
        if (persistUser) {
          await SecureStorageService.saveUserEntity(user);
        }
        if (afterSuccess != null) {
          await afterSuccess(user);
        }
        emitSuccess(user);
      },
    );
  }
}
