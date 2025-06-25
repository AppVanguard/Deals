import 'package:deals/core/utils/logger.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:deals/core/errors/exception.dart';
import 'package:deals/generated/l10n.dart'; // Assuming generated localization file

abstract class CustomFirebaseException extends FirebaseAuthException {
  CustomFirebaseException({required super.code});

  static CustomException getFirebaseAuthException(String code) {
    appLog("Exception code: $code");
    switch (code) {
      case 'email-already-in-use':
        return CustomException(S.current.emailAlreadyInUse);
      case 'weak-password':
        return CustomException(S.current.weakPassword);
      case 'invalid-email':
        return CustomException(S.current.invalidEmail);
      case 'operation-not-allowed':
        return CustomException(S.current.operationNotAllowed);
      case 'network-request-failed':
        return CustomException(S.current.networkRequestFailed);
      case 'too-many-requests':
        return CustomException(S.current.tooManyRequests);
      case 'user-disabled':
        return CustomException(S.current.userDisabled);
      case 'user-not-found':
        return CustomException(S.current.userNotFound);
      case 'wrong-password':
        return CustomException(S.current.wrongPassword);
      case 'internal-error':
        return CustomException(S.current.internalError);
      case 'invalid-credential':
        return CustomException(S.current.invalidCredential);
      case 'invalid-verification-code':
        return CustomException(S.current.invalidVerificationCode);
      case 'invalid-verification-id':
        return CustomException(S.current.invalidVerificationId);
      case 'account-exists-with-different-credential':
        return CustomException(S.current.accountExistsWithDifferentCredential);
      case 'credential-already-in-use':
        return CustomException(S.current.credentialAlreadyInUse);
      case 'popup-closed-by-user':
        return CustomException(S.current.popupClosedByUser);
      case 'auth-domain-config-required':
        return CustomException(S.current.authDomainConfigRequired);
      case 'cancelled-popup-request':
        return CustomException(S.current.cancelledPopupRequest);
      case 'operation-not-supported-in-this-environment':
        return CustomException(S.current.operationNotSupportedInThisEnvironment);
      case 'provider-already-linked':
        return CustomException(S.current.providerAlreadyLinked);
      case 'requires-recent-login':
        return CustomException(S.current.requiresRecentLogin);
      case 'web-storage-unsupported':
        return CustomException(S.current.webStorageUnsupported);
      default:
        return CustomException(S.current.unknownError);
    }
  }
}
