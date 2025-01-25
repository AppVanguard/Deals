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
