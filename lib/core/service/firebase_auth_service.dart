import 'dart:io';
import 'dart:convert';
import 'package:deals/core/utils/logger.dart';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:deals/constants.dart';
import 'package:deals/core/errors/custom_firebase_exception.dart';
import 'package:deals/core/errors/exception.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/generated/l10n.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/// A service class that wraps direct calls to Firebase Auth SDK:
/// 1. createUserWithEmailAndPassword
/// 2. signInWithEmailAndPassword
/// 3. Third-party provider sign in (Google, Facebook, Apple)
class FirebaseAuthService {
  /// Create a user with [email] and [password] using FirebaseAuth.
  /// Returns the [User] object upon success or throws an exception upon failure.
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      appLog('FirebaseAuthService: Created user -> ${credential.user?.uid}');
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      appLog(
          'Error in FirebaseAuthService.createUserWithEmailAndPassword: ${e.code}');
      throw CustomFirebaseException.getFirebaseAuthException(e.code);
    } catch (e) {
      appLog('Unknown error in createUserWithEmailAndPassword: $e');
      throw CustomException(S.current.SomethingWentWrong);
    }
  }

  /// Sign in a user with [email] and [password].
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      appLog(
          'Error in FirebaseAuthService.signInWithEmailAndPassword: ${e.code}');
      throw CustomFirebaseException.getFirebaseAuthException(e.code);
    } catch (e) {
      appLog('Unknown error in signInWithEmailAndPassword: $e');
      throw CustomException(S.current.SomethingWentWrong);
    }
  }

  /// Sign in with Google using [GoogleSignIn].
  Future<User> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();

      // Force a full sign-out to guarantee the account chooser shows up:
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in flow
        throw CustomException(S.current.SomethingWentWrong);
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return (await FirebaseAuth.instance.signInWithCredential(credential))
          .user!;
    } on FirebaseAuthException catch (e) {
      appLog('Error in FirebaseAuthService.signInWithGoogle: ${e.code}');
      throw CustomFirebaseException.getFirebaseAuthException(e.code);
    } catch (e) {
      appLog('Error in FirebaseAuthService.signInWithGoogle: ${e.toString()}');
      throw CustomException(S.current.SomethingWentWrong);
    }
  }

  /// Sign in with Facebook using [FacebookAuth].
  Future<User> signInWithFacebook() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        nonce: nonce,
      );

      if (loginResult.accessToken == null) {
        throw CustomException(S.current.FacebookError);
      }

      OAuthCredential facebookAuthCredential;

      // Platform check for iOS limited login vs classic
      if (Platform.isIOS) {
        switch (loginResult.accessToken!.type) {
          case AccessTokenType.classic:
            final token = loginResult.accessToken as ClassicToken;
            facebookAuthCredential =
                FacebookAuthProvider.credential(token.authenticationToken!);
            break;
          case AccessTokenType.limited:
            final token = loginResult.accessToken as LimitedToken;
            facebookAuthCredential = OAuthCredential(
              providerId: 'facebook.com',
              signInMethod: 'oauth',
              idToken: token.tokenString,
              rawNonce: rawNonce,
            );
            break;
        }
      } else {
        // Android or other platforms
        facebookAuthCredential = FacebookAuthProvider.credential(
          loginResult.accessToken!.tokenString,
        );
      }

      final userCred = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      return userCred.user!;
    } on FirebaseAuthException catch (e) {
      appLog('Error in FirebaseAuthService.signInWithFacebook: ${e.code}');
      throw CustomFirebaseException.getFirebaseAuthException(e.code);
    } catch (e) {
      appLog('Unknown error in signInWithFacebook: $e');
      throw CustomException(S.current.SomethingWentWrong);
    }
  }

  /// Sign in with Apple using the official Firebase recommended approach.
  Future<User> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return userCred.user!;
    } on FirebaseAuthException catch (e) {
      appLog(
        'Error in FirebaseAuthService.signInWithApple: ${e.code} ${e.message}',
      );
      throw CustomFirebaseException.getFirebaseAuthException(e.code);
    } catch (e, s) {
      appLog('Unknown error in signInWithApple: $e', stackTrace: s);
      throw CustomException(S.current.SomethingWentWrong);
    }
  }

  /// Deletes the currently signed in user from FirebaseAuth.
  Future<void> deleteUser() async {
    await FirebaseAuth.instance.currentUser?.delete();
  }

  /// Utility function to generate a cryptographically secure nonce.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Checks if there is currently an authenticated user.
  bool isSignedIn() {
    // Check the rememberMe preference and FirebaseAuth current user
    bool rememberMe = Prefs.getBool(kRememberMe);
    appLog('Remember me: $rememberMe');
    var x = FirebaseAuth.instance.currentUser != null && rememberMe;
    appLog('isSignedIn: $x');
    return x;
  }
}
