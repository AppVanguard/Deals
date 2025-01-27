import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_pocket/core/errors/custom_firebase_exception.dart';
import 'package:in_pocket/core/errors/exception.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseAuthService {
  Future deleteUser() async =>
      await FirebaseAuth.instance.currentUser!.delete();
  // Sign in with email and password
  Future<User> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(credential.user!.toString());
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log('Error in FirebaseAuthService.createUserWithEmailAndPassword: ${e.code}');
      throw CustomFirebaseException.getFirbaseAuthException(e.code);
    } catch (e) {
      log('Error in FirebaseAuthService.createUserWithEmailAndPassword: ${e.toString()}');
      throw CustomExeption('حدث خطأ ما , يرجى المحاولة مرة أخرى');
    }
  }

  Future<User> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log('Error in FirebaseAuthService.signInWithEmailAndPassword: ${e.code}');
      throw CustomFirebaseException.getFirbaseAuthException(e.code);
    } catch (e) {
      log('Error in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()}');
      throw CustomExeption('حدث خطأ ما , يرجى المحاولة مرة أخرى');
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return (await FirebaseAuth.instance.signInWithCredential(credential))
          .user!;
    } on FirebaseAuthException catch (e) {
      log('Error in FirebaseAuthService.signInWithGoogle: ${e.code}');
      throw CustomFirebaseException.getFirbaseAuthException(e.code);
    } catch (e) {
      log('Error in FirebaseAuthService.signInWithGoogle: ${e.toString()}');
      throw CustomExeption('حدث خطأ ما , يرجى المحاولة مرة أخرى');
    }
  }

  Future<User> signInWithFacebook() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        nonce: nonce,
      );

      OAuthCredential facebookAuthCredential;

      if (Platform.isIOS) {
        switch (loginResult.accessToken!.type) {
          case AccessTokenType.classic:
            final token = loginResult.accessToken as ClassicToken;
            facebookAuthCredential = FacebookAuthProvider.credential(
              token.authenticationToken!,
            );
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
        facebookAuthCredential = FacebookAuthProvider.credential(
          loginResult.accessToken!.tokenString,
        );
      }
      return (await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential))
          .user!;
    } on FirebaseAuthException catch (e) {
      log('Error in FirebaseAuthService.signInWithFacebook: ${e.code}');
      throw CustomFirebaseException.getFirbaseAuthException(e.code);
    } catch (e) {
      log('Error in FirebaseAuthService.signInWithFacebook: ${e.toString()}');
      throw CustomExeption('حدث خطأ ما , يرجى المحاولة مرة أخرى');
    }
  }

  Future<User> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    return (await FirebaseAuth.instance.signInWithCredential(oauthCredential))
        .user!;
  }

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

  bool isSignedIn() => FirebaseAuth.instance.currentUser != null;
}
