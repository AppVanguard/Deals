// lib/main.dart

import 'package:deals/core/helper_functions/app_router.dart';
import 'package:deals/features/notifications/data/data_source/notification_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:deals/core/manager/cubit/local_cubit/local_cubit.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/firebase_options.dart';
import 'package:deals/generated/l10n.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();
  await Hive.initFlutter();
  Hive.registerAdapter(NotificationLocalAdapter());
  await Hive.openBox<NotificationLocal>('notificationsBox');

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
            options.dsn = dotenv.env['SENTRY_DSN'] ?? '';
            options.sendDefaultPii = true;
          },
          appRunner: () {
            runApp(
              BlocProvider(
                create: (context) => LocaleCubit(),
                child: const Deals(),
              ),
            );
          },
        )
      : runApp(
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
        return MaterialApp.router(
          // Our GoRouter
          routerConfig: AppRouter.router,
          // Theming
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            fontFamily: 'Roboto',
          ),
          // Localization
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: locale,

          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
