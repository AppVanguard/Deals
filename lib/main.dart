import 'package:deals/core/utils/logger.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:deals/core/helper_functions/app_router.dart';
import 'package:deals/core/manager/cubit/local_cubit/local_cubit.dart';
import 'package:deals/core/manager/cubit/session_cubit/session_cubit.dart';
import 'package:deals/core/manager/simple_bloc_observer.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/widgets/app_error_widget.dart';
import 'package:deals/features/notifications/data/data_source/notification_local.dart';
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'package:deals/firebase_options.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/core/utils/firebase_utils.dart';

// 1) Local notifications plugin
// The notifications plugin instance is provided from firebase_utils.dart

// 2) Global guard to ensure we only attach the onMessage listener once
bool _didAttachFcmListener = false;

void initBlocObserver() {
  Bloc.observer = SimpleBlocObserver();
}

Future<void> runWithSentry(VoidCallback appRunner) async {
  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN'] ?? '';
      options.sendDefaultPii = true;
    },
    appRunner: appRunner,
  );
}

/// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  appLog('Handling a background message: ${message.messageId}');
  // Optionally do local DB or schedule local notification here
}

/// Initialize local notifications

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NotificationLocalAdapter());
  await Hive.openBox<NotificationLocal>('notificationsBox');
}

void _setupBlocAndErrors() {
  Bloc.observer = SimpleBlocObserver();
  FlutterError.onError = (details) {
    Sentry.captureException(details.exception, stackTrace: details.stack);
    FlutterError.presentError(details);
  };
  ErrorWidget.builder = (details) => AppErrorWidget(details: details);
}

Future<void> _initSentry(Future<void> Function() runner) {
  return SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN'] ?? '';
      options.sendDefaultPii = true;
    },
    appRunner: runner,
  );
}

void _attachFcmListener() {
  if (_didAttachFcmListener) return;
  _didAttachFcmListener = true;
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    appLog('Foreground message received: ${message.messageId}');
    await showFlutterNotification(message);
    if (getIt.isRegistered<NotificationsCubit>()) {
      getIt<NotificationsCubit>().handleIncomingForegroundMessage(message);
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    appLog('Notification caused app to open: ${message.messageId}');
  });
}

void _listenFcmTokenRefresh() {
  FirebaseMessaging.instance.onTokenRefresh.listen(
    (newToken) => appLog('FCM token refreshed: $newToken'),
  );
}

Future<void> requestNotificationPermissions() async {
  final settings = await requestPushPermission();
  switch (settings.authorizationStatus) {
    case AuthorizationStatus.authorized:
      appLog('User granted notification permission');
      break;
    case AuthorizationStatus.provisional:
      appLog('User granted provisional notification permission');
      break;
    default:
      appLog('User declined or has not accepted notification permission');
  }
}

Widget _buildApp() {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => LocaleCubit()),
      BlocProvider(create: (_) => SessionCubit()),
    ],
    child: const DealsApp(),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setupBlocAndErrors();

  await dotenv.load();

  await Future.wait([
    _initHive(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    Prefs.init(),
  ]);

  setupGetit();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initializeNotifications();
  await requestNotificationPermissions();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  _attachFcmListener();
  _listenFcmTokenRefresh();
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    appLog('Notification opened app from terminated state: '
        '${initialMessage.messageId}');
  }
  if (!kReleaseMode) {
    final token = await getFcmToken();
    appLog('Initial FCM token: $token');
  }

  Future<void> runner() async {
    runApp(_buildApp());
  }

  if (kReleaseMode) {
    await _initSentry(runner);
  } else {
    await runner();
  }
}

class DealsApp extends StatelessWidget {
  const DealsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
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
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
