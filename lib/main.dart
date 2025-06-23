import 'dart:developer';
import 'package:deals/core/helper_functions/app_router.dart';
import 'package:deals/features/notifications/data/data_source/notification_local.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';
import 'package:deals/features/search/presentation/manager/search_cubit/search_cubit.dart';
import 'package:deals/firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:deals/core/manager/cubit/local_cubit/local_cubit.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/generated/l10n.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:deals/core/manager/simple_bloc_observer.dart';
import 'package:deals/core/widgets/app_error_widget.dart';
import 'package:deals/core/manager/cubit/session_cubit/session_cubit.dart';
import 'package:deals/features/search/presentation/manager/search_cubit/search_cubit.dart';

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
  const DarwinInitializationSettings
  iosInitSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    // onDidReceiveLocalNotification: (id, title, body, payload) { /* iOS < 10 callback */ },
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global Bloc and error handlers
  Bloc.observer = SimpleBlocObserver();
  FlutterError.onError = (details) {
    Sentry.captureException(details.exception, stackTrace: details.stack);
    FlutterError.presentError(details);
  };
  ErrorWidget.builder = (details) => AppErrorWidget(details: details);

  // 1) Load env variables
  await dotenv.load();

  // 2) Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(NotificationLocalAdapter());
  await Hive.openBox<NotificationLocal>('notificationsBox');

  // 3) Firebase initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 4) SharedPreferences
  await Prefs.init();

  // 5) Setup GetIt
  setupGetit();

  // 6) Setup background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 7) Init local notifications plugin
  await initializeLocalNotifications();

  // 8) Ask for permissions (iOS)
  await FirebaseMessaging.instance.requestPermission();

  // 9) Attach the SINGLE onMessage listener if not attached
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

  // 10) If user taps a notification that opens the app
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    log("Notification caused app to open: ${message.messageId}");
    // Optionally do navigation or logic
  });

  // 11) Finally run the app
  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn = dotenv.env['SENTRY_DSN'] ?? '';
        options.sendDefaultPii = true;
      },
      appRunner: () => runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LocaleCubit()),
            BlocProvider(create: (_) => SessionCubit()),
            BlocProvider(create: (_) => SearchCubit()),
          ],
          child: const Deals(),
        ),
      ),
    );
  } else {
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LocaleCubit()),
          BlocProvider(create: (_) => SessionCubit()),
          BlocProvider(create: (_) => SearchCubit()),
        ],
        child: const Deals(),
      ),
    );
  }
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
