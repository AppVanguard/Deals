import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/helper_functions/app_router.dart';
import 'core/manager/cubit/local_cubit/local_cubit.dart';
import 'core/manager/cubit/session_cubit/session_cubit.dart';
import 'core/manager/simple_bloc_observer.dart';
import 'core/service/get_it_service.dart';
import 'core/service/shared_prefrences_singleton.dart';
import 'core/utils/app_colors.dart';
import 'core/widgets/app_error_widget.dart';
import 'features/notifications/data/data_source/notification_local.dart';
import 'features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';

// 1) Local notifications plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 2) Global guard to ensure we only attach the onMessage listener once
bool _didAttachFcmListener = false;

/// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling a background message: ${message.messageId}');
  // Optionally do local DB or schedule local notification here
}

/// Initialize local notifications
Future<void> initializeLocalNotifications() async {
  // Android settings:
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS / Darwin settings (v10+ uses DarwinInitializationSettings):
  const DarwinInitializationSettings iosInitSettings = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  // Combine them:
  const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
    iOS: iosInitSettings, // ← important for iOS
  );

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle user tapping on a notification
      log('Tapped notification payload: ${response.payload}');
    },
  );
}

/// Show local notification in the system tray
Future<void> showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    channelDescription:
        'This channel is used for notifications that require immediate attention',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails notifDetails = NotificationDetails(
    android: androidDetails,
    // You can also add `darwin: DarwinNotificationDetails(...)` here
    // if you want to customize the iOS side of the notification.
  );
  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title,
    message.notification?.body,
    notifDetails,
  );
}

void setupBloc() {
  Bloc.observer = SimpleBlocObserver();
  FlutterError.onError = (details) {
    Sentry.captureException(details.exception, stackTrace: details.stack);
    FlutterError.presentError(details);
  };
  ErrorWidget.builder = (details) => AppErrorWidget(details: details);
}

Future<void> runWithSentry(Widget app) async {
  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn = dotenv.env['SENTRY_DSN'] ?? '';
        options.sendDefaultPii = true;
      },
      appRunner: () => runApp(app),
    );
  } else {
    runApp(app);
  }
}

Widget buildRootApp() {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => LocaleCubit()),
      BlocProvider(create: (_) => SessionCubit()),
    ],
    child: const Deals(),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupBloc();

  // 1) Batch async initializers in parallel
  final envFuture = dotenv.load();
  final hiveFuture = Hive.initFlutter().then((_) async {
    Hive.registerAdapter(NotificationLocalAdapter());
    await Hive.openBox<NotificationLocal>('notificationsBox');
  });
  final firebaseFuture =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefsFuture = Prefs.init();

  await Future.wait([envFuture, hiveFuture, firebaseFuture, prefsFuture]);

  // 2) Setup GetIt
  setupGetit();

  // 3) Setup background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 4) Init local notifications plugin
  await initializeLocalNotifications();

  // 5) Attach the SINGLE onMessage listener if not attached
  if (!_didAttachFcmListener) {
    _didAttachFcmListener = true;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("Foreground message received: ${message.messageId}");

      // Show local heads-up or tray notification
      await showLocalNotification(message);

      // If we have a NotificationsCubit, pass the message to it
      if (getIt.isRegistered<NotificationsCubit>()) {
        getIt<NotificationsCubit>().handleIncomingForegroundMessage(message);
      }
    });
  }

  // 6) If user taps a notification that opens the app
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    log("Notification caused app to open: ${message.messageId}");
    // Optionally do navigation or logic
  });

  // 7) Finally run the app with Sentry in release mode
  await runWithSentry(buildRootApp());
}

class Deals extends StatelessWidget {
  const Deals({super.key});

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
