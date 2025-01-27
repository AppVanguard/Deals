import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_pocket/core/errors/exception.dart';

abstract class CustomFirebaseException extends FirebaseAuthException {
  CustomFirebaseException({required super.code});

  static CustomExeption getFirbaseAuthException(String code) {
    log("exception code: $code");
    if (code == 'email-already-in-use') {
      return CustomExeption('الحساب موجود بالفعل');
    } else if (code == 'weak-password') {
      return CustomExeption('كلمة المرور ضعيفة');
    } else if (code == 'invalid-email') {
      return CustomExeption('يرجي كتابة البريد الإلكتروني بشكل صحيح');
    } else if (code == 'operation-not-allowed') {
      return CustomExeption('التسجيل غير مفعل');
    } else if (code == 'network-request-failed') {
      return CustomExeption('لا يوجد اتصال بالإنترنت');
    } else if (code == 'too-many-requests') {
      return CustomExeption('تم تجاوز الحد الأقصى لعدد المحاولات');
    } else if (code == 'user-disabled') {
      return CustomExeption('الحساب معطل');
    } else if (code == 'user-not-found') {
      return CustomExeption('الحساب غير موجود');
    } else if (code == 'wrong-password') {
      return CustomExeption('كلمة المرور غير صحيحة');
    } else if (code == 'internal-error') {
      return CustomExeption('حدث خطاء ما');
    } else if (code == 'invalid-credential') {
      return CustomExeption('بيانات الحساب غير صحيحة');
    } else if (code == 'invalid-verification-code') {
      return CustomExeption('كود التحقق غير صحيح');
    } else if (code == 'invalid-verification-id') {
      return CustomExeption('كود التحقق غير صحيح');
    } else if (code == 'account-exists-with-different-credential') {
      return CustomExeption(
          'الحساب مسجل بمزود مختلف، يرجى تسجيل الدخول باستخدام المزود المرتبط');
    } else if (code == 'credential-already-in-use') {
      return CustomExeption('بيانات الاعتماد مستخدمة بالفعل');
    } else if (code == 'popup-closed-by-user') {
      return CustomExeption('تم إغلاق النافذة المنبثقة قبل إكمال العملية');
    } else if (code == 'invalid-verification-id') {
      return CustomExeption('كود التحقق غير صحيح');
    } else if (code == 'auth-domain-config-required') {
      return CustomExeption('إعدادات مجال المصادقة مفقودة');
    } else if (code == 'cancelled-popup-request') {
      return CustomExeption('تم إلغاء النافذة المنبثقة');
    } else if (code == 'operation-not-supported-in-this-environment') {
      return CustomExeption('عملية المصادقة غير مدعومة في هذا البيئة');
    } else if (code == 'provider-already-linked') {
      return CustomExeption('تم ربط الحساب بالفعل بمزود مختلف');
    } else if (code == 'requires-recent-login') {
      return CustomExeption('يرجى تسجيل الدخول مرة أخرى لإكمال العملية');
    } else if (code == 'web-storage-unsupported') {
      return CustomExeption('تخزين الويب غير مدعوم في المتصفح الحالي');
    } else {
      return CustomExeption('حدث خطأ ما');
    }
  }
}
