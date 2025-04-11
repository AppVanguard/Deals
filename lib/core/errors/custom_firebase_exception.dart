import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:deals/core/errors/exception.dart';
import 'package:deals/generated/l10n.dart'; // Assuming generated localization file

abstract class CustomFirebaseException extends FirebaseAuthException {
  CustomFirebaseException({required super.code});

  static CustomExeption getFirebaseAuthException(String code) {
    log("Exception code: $code");
    switch (code) {
      case 'email-already-in-use':
        return CustomExeption(S.current.emailAlreadyInUse);
      case 'weak-password':
        return CustomExeption(S.current.weakPassword);
      case 'invalid-email':
        return CustomExeption(S.current.invalidEmail);
      case 'operation-not-allowed':
        return CustomExeption(S.current.operationNotAllowed);
      case 'network-request-failed':
        return CustomExeption(S.current.networkRequestFailed);
      case 'too-many-requests':
        return CustomExeption(S.current.tooManyRequests);
      case 'user-disabled':
        return CustomExeption(S.current.userDisabled);
      case 'user-not-found':
        return CustomExeption(S.current.userNotFound);
      case 'wrong-password':
        return CustomExeption(S.current.wrongPassword);
      case 'internal-error':
        return CustomExeption(S.current.internalError);
      case 'invalid-credential':
        return CustomExeption(S.current.invalidCredential);
      case 'invalid-verification-code':
        return CustomExeption(S.current.invalidVerificationCode);
      case 'invalid-verification-id':
        return CustomExeption(S.current.invalidVerificationId);
      case 'account-exists-with-different-credential':
        return CustomExeption(S.current.accountExistsWithDifferentCredential);
      case 'credential-already-in-use':
        return CustomExeption(S.current.credentialAlreadyInUse);
      case 'popup-closed-by-user':
        return CustomExeption(S.current.popupClosedByUser);
      case 'auth-domain-config-required':
        return CustomExeption(S.current.authDomainConfigRequired);
      case 'cancelled-popup-request':
        return CustomExeption(S.current.cancelledPopupRequest);
      case 'operation-not-supported-in-this-environment':
        return CustomExeption(S.current.operationNotSupportedInThisEnvironment);
      case 'provider-already-linked':
        return CustomExeption(S.current.providerAlreadyLinked);
      case 'requires-recent-login':
        return CustomExeption(S.current.requiresRecentLogin);
      case 'web-storage-unsupported':
        return CustomExeption(S.current.webStorageUnsupported);
      default:
        return CustomExeption(S.current.unknownError);
    }
  }
}
