import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';

String generateNonce([int l = 32]) {
  const cs = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
  final r = Random.secure();
  return List.generate(l, (_) => cs[r.nextInt(cs.length)]).join();
}

String sha256ofString(String s) => sha256.convert(utf8.encode(s)).toString();

Future<UserCredential> signInWithApple() async {
  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);
  final cred = await SignInWithApple.getAppleIDCredential(
    scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    nonce: nonce,
  );
  final o = OAuthProvider("apple.com").credential(
    idToken: cred.identityToken,
    rawNonce: rawNonce,
  );
  return FirebaseAuth.instance.signInWithCredential(o);
}
