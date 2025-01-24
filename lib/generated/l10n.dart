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
