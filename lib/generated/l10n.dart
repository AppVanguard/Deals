// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Save money with us`
  String get p1OnBoardingTittle {
    return Intl.message(
      'Save money with us',
      name: 'p1OnBoardingTittle',
      desc: '',
      args: [],
    );
  }

  /// `Join now`
  String get JoinNow {
    return Intl.message(
      'Join now',
      name: 'JoinNow',
      desc: '',
      args: [],
    );
  }

  /// `Deal with`
  String get p1OnBoardingSubTittleFirstWord {
    return Intl.message(
      'Deal with',
      name: 'p1OnBoardingSubTittleFirstWord',
      desc: '',
      args: [],
    );
  }

  /// `more than 200 stores offering great cashback and coupons.`
  String get p1OnBoardingSubTittle {
    return Intl.message(
      'more than 200 stores offering great cashback and coupons.',
      name: 'p1OnBoardingSubTittle',
      desc: '',
      args: [],
    );
  }

  /// `Explore cashback & coupons`
  String get p2OnBoardingTittle {
    return Intl.message(
      'Explore cashback & coupons',
      name: 'p2OnBoardingTittle',
      desc: '',
      args: [],
    );
  }

  /// `Explore`
  String get p2OnBoardingSubTittleFirstWord {
    return Intl.message(
      'Explore',
      name: 'p2OnBoardingSubTittleFirstWord',
      desc: '',
      args: [],
    );
  }

  /// `several categories of cashback and coupons.`
  String get p2OnBoardingSubTittle {
    return Intl.message(
      'several categories of cashback and coupons.',
      name: 'p2OnBoardingSubTittle',
      desc: '',
      args: [],
    );
  }

  /// `Refer and earn`
  String get p3OnBoardingTittle {
    return Intl.message(
      'Refer and earn',
      name: 'p3OnBoardingTittle',
      desc: '',
      args: [],
    );
  }

  /// `Refer`
  String get p3OnBoardingSubTittleFirstWord {
    return Intl.message(
      'Refer',
      name: 'p3OnBoardingSubTittleFirstWord',
      desc: '',
      args: [],
    );
  }

  /// `your friends and earn 70$ per everyone registers with your referral code. `
  String get p3OnBoardingSubTittle {
    return Intl.message(
      'your friends and earn 70\$ per everyone registers with your referral code. ',
      name: 'p3OnBoardingSubTittle',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get GetStarted {
    return Intl.message(
      'Get Started',
      name: 'GetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get Next {
    return Intl.message(
      'Next',
      name: 'Next',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get Previous {
    return Intl.message(
      'Previous',
      name: 'Previous',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account ?`
  String get HaveAccount {
    return Intl.message(
      'Already have an account ?',
      name: 'HaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get Login {
    return Intl.message(
      'Login',
      name: 'Login',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account?`
  String get DontHaveAccount {
    return Intl.message(
      'Don’t have an account?',
      name: 'DontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get createAccount {
    return Intl.message(
      'Create account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get CreateNewAccount {
    return Intl.message(
      'Create New Account',
      name: 'CreateNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get SignUp {
    return Intl.message(
      'Sign Up',
      name: 'SignUp',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Email {
    return Intl.message(
      'Email',
      name: 'Email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message(
      'Password',
      name: 'Password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get ConfirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'ConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email or phone`
  String get EmailOrPhone {
    return Intl.message(
      'Email or phone',
      name: 'EmailOrPhone',
      desc: '',
      args: [],
    );
  }

  /// `Remember me?`
  String get RememberMe {
    return Intl.message(
      'Remember me?',
      name: 'RememberMe',
      desc: '',
      args: [],
    );
  }

  /// `Forget the password?`
  String get ForgotPassword {
    return Intl.message(
      'Forget the password?',
      name: 'ForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forget password`
  String get ForgotPasswordTittle {
    return Intl.message(
      'Forget password',
      name: 'ForgotPasswordTittle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get EnterYourEmail {
    return Intl.message(
      'Enter your email address',
      name: 'EnterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get FieldRequired {
    return Intl.message(
      'This field is required',
      name: 'FieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `or login with`
  String get LoginWith {
    return Intl.message(
      'or login with',
      name: 'LoginWith',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get FullName {
    return Intl.message(
      'Full Name',
      name: 'FullName',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get Phone {
    return Intl.message(
      'Phone',
      name: 'Phone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email or phone.`
  String get EPValidator {
    return Intl.message(
      'Please enter your email or phone.',
      name: 'EPValidator',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password.`
  String get PasswordValidator {
    return Intl.message(
      'Please enter your password.',
      name: 'PasswordValidator',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your full name.`
  String get FNValidator {
    return Intl.message(
      'Please enter your full name.',
      name: 'FNValidator',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone.`
  String get PhoneValidator {
    return Intl.message(
      'Please enter your phone.',
      name: 'PhoneValidator',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email.`
  String get EmailValidator {
    return Intl.message(
      'Please enter your email.',
      name: 'EmailValidator',
      desc: '',
      args: [],
    );
  }

  /// `Password not match.`
  String get PasswordNotMatch {
    return Intl.message(
      'Password not match.',
      name: 'PasswordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get Register {
    return Intl.message(
      'Register',
      name: 'Register',
      desc: '',
      args: [],
    );
  }

  /// `or register with`
  String get OrRegisterWith {
    return Intl.message(
      'or register with',
      name: 'OrRegisterWith',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get AlreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'AlreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Unknow error`
  String get UnknowError {
    return Intl.message(
      'Unknow error',
      name: 'UnknowError',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get SomethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'SomethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Facebook login failed or was cancelled`
  String get FacebookError {
    return Intl.message(
      'Facebook login failed or was cancelled',
      name: 'FacebookError',
      desc: '',
      args: [],
    );
  }

  /// `Google login failed or was cancelled`
  String get GoogleError {
    return Intl.message(
      'Google login failed or was cancelled',
      name: 'GoogleError',
      desc: '',
      args: [],
    );
  }

  /// `The account already exists.`
  String get emailAlreadyInUse {
    return Intl.message(
      'The account already exists.',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `The password is too weak.`
  String get weakPassword {
    return Intl.message(
      'The password is too weak.',
      name: 'weakPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Registration is not enabled.`
  String get operationNotAllowed {
    return Intl.message(
      'Registration is not enabled.',
      name: 'operationNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection.`
  String get networkRequestFailed {
    return Intl.message(
      'No internet connection.',
      name: 'networkRequestFailed',
      desc: '',
      args: [],
    );
  }

  /// `Too many requests have been made.`
  String get tooManyRequests {
    return Intl.message(
      'Too many requests have been made.',
      name: 'tooManyRequests',
      desc: '',
      args: [],
    );
  }

  /// `The account is disabled.`
  String get userDisabled {
    return Intl.message(
      'The account is disabled.',
      name: 'userDisabled',
      desc: '',
      args: [],
    );
  }

  /// `The account does not exist.`
  String get userNotFound {
    return Intl.message(
      'The account does not exist.',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `The password is incorrect.`
  String get wrongPassword {
    return Intl.message(
      'The password is incorrect.',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred.`
  String get internalError {
    return Intl.message(
      'An error occurred.',
      name: 'internalError',
      desc: '',
      args: [],
    );
  }

  /// `The account credentials are invalid.`
  String get invalidCredential {
    return Intl.message(
      'The account credentials are invalid.',
      name: 'invalidCredential',
      desc: '',
      args: [],
    );
  }

  /// `The verification code is invalid.`
  String get invalidVerificationCode {
    return Intl.message(
      'The verification code is invalid.',
      name: 'invalidVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `The verification ID is invalid.`
  String get invalidVerificationId {
    return Intl.message(
      'The verification ID is invalid.',
      name: 'invalidVerificationId',
      desc: '',
      args: [],
    );
  }

  /// `The account is registered with a different provider. Please log in with the linked provider.`
  String get accountExistsWithDifferentCredential {
    return Intl.message(
      'The account is registered with a different provider. Please log in with the linked provider.',
      name: 'accountExistsWithDifferentCredential',
      desc: '',
      args: [],
    );
  }

  /// `The credential is already in use.`
  String get credentialAlreadyInUse {
    return Intl.message(
      'The credential is already in use.',
      name: 'credentialAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `The popup window was closed before completing the operation.`
  String get popupClosedByUser {
    return Intl.message(
      'The popup window was closed before completing the operation.',
      name: 'popupClosedByUser',
      desc: '',
      args: [],
    );
  }

  /// `Authentication domain configuration is missing.`
  String get authDomainConfigRequired {
    return Intl.message(
      'Authentication domain configuration is missing.',
      name: 'authDomainConfigRequired',
      desc: '',
      args: [],
    );
  }

  /// `The popup request was canceled.`
  String get cancelledPopupRequest {
    return Intl.message(
      'The popup request was canceled.',
      name: 'cancelledPopupRequest',
      desc: '',
      args: [],
    );
  }

  /// `Authentication is not supported in this environment.`
  String get operationNotSupportedInThisEnvironment {
    return Intl.message(
      'Authentication is not supported in this environment.',
      name: 'operationNotSupportedInThisEnvironment',
      desc: '',
      args: [],
    );
  }

  /// `The account is already linked to a provider.`
  String get providerAlreadyLinked {
    return Intl.message(
      'The account is already linked to a provider.',
      name: 'providerAlreadyLinked',
      desc: '',
      args: [],
    );
  }

  /// `Please log in again to complete the operation.`
  String get requiresRecentLogin {
    return Intl.message(
      'Please log in again to complete the operation.',
      name: 'requiresRecentLogin',
      desc: '',
      args: [],
    );
  }

  /// `Web storage is not supported in the current browser.`
  String get webStorageUnsupported {
    return Intl.message(
      'Web storage is not supported in the current browser.',
      name: 'webStorageUnsupported',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error occurred.`
  String get unknownError {
    return Intl.message(
      'An unknown error occurred.',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Send code`
  String get SendCode {
    return Intl.message(
      'Send code',
      name: 'SendCode',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get Verify {
    return Intl.message(
      'Verify',
      name: 'Verify',
      desc: '',
      args: [],
    );
  }

  /// `OTP Verification`
  String get OTPVerification {
    return Intl.message(
      'OTP Verification',
      name: 'OTPVerification',
      desc: '',
      args: [],
    );
  }

  /// `A 4-digit code has been sent to `
  String get OTPSent {
    return Intl.message(
      'A 4-digit code has been sent to ',
      name: 'OTPSent',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the 4-digit code.`
  String get OTPValidator {
    return Intl.message(
      'Please enter the 4-digit code.',
      name: 'OTPValidator',
      desc: '',
      args: [],
    );
  }

  /// `Invalid code`
  String get InvalidCode {
    return Intl.message(
      'Invalid code',
      name: 'InvalidCode',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
