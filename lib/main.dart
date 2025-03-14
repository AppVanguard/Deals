import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:deals/core/helper_functions/on_generate_routes.dart';
import 'package:deals/core/manager/cubit/local_cubit/local_cubit.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/firebase_options.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/features/splash/presentation/views/splash_view.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv

void main() async {
  // Ensure that Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the .env file
  await dotenv.load();

  // Initialize Firebase and SharedPreferences
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Prefs.init();

  // Setup GetIt service locator
  setupGetit();

  // Check if we are in release mode (production)
  kReleaseMode
      ? await SentryFlutter.init(
          (options) {
            // Retrieve the DSN securely from environment variables
            options.dsn =
                dotenv.env['SENTRY_DSN'] ?? ''; // Default empty if not found
            options.sendDefaultPii =
                true; // Include personally identifiable information (PII)
          },
          appRunner: () {
            // Run the app wrapped in the necessary BlocProvider
            runApp(
              BlocProvider(
                create: (context) => LocaleCubit(),
                child: const Deals(),
              ),
            );
          },
        )
      :
      // In debug/development mode, run the app without Sentry
      runApp(
          BlocProvider(
            create: (context) => LocaleCubit(),
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
