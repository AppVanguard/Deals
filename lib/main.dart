import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_pocket/core/helper_functions/on_generate_routes.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/generated/l10n.dart';
import 'package:in_pocket/splash_view/presentation/views/splash_view.dart';

void main() {
  runApp(const InPocket());
}

class InPocket extends StatelessWidget {
  const InPocket({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          fontFamily: 'Cairo'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: const Locale('en'),
      initialRoute: SplashView.routeName,
      onGenerateRoute: onGenerateRoute,
      home: const SplashView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
