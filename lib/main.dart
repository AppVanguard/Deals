import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:deals/core/helper_functions/on_generate_routes.dart';
import 'package:deals/core/manager/cubit/local_cubit.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/firebase_options.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/features/splash/presentation/views/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 1) Initialize SharedPreferences
  await Prefs.init();
  // 2) Setup GetIt
  setupGetit();
  // 3) Run the app
  runApp(
    BlocProvider(
      create: (context) => LocaleCubit(), // Provide your LocaleCubit globally
      child: const Deals(),
    ),
  );
}

class Deals extends StatelessWidget {
  const Deals({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            fontFamily: 'Roboto',
          ),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: locale,
          initialRoute: SplashView.routeName,
          onGenerateRoute: onGenerateRoute,
          home: const SplashView(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
