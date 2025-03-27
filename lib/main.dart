// lib/main.dart

import 'dart:developer';

import 'package:deals/core/helper_functions/app_router.dart';
import 'package:deals/features/notifications/data/data_source/notification_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Background message handler for FCM.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling a background message: ${message.messageId}');
  // You can update local storage or trigger a local notification here if needed.
}

/// Initializes the local notifications plugin.
Future<void> initializeLocalNotifications() async {
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitializationSettings);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

/// Displays a local notification when a message is received in the foreground.
Future<void> showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'high_importance_channel', // Channel ID
    'High Importance Notifications', // Channel Name
    channelDescription:
        'This channel is used for notifications that require immediate attention',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title,
    message.notification?.body,
    notificationDetails,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables.
  await dotenv.load();

  // Initialize Hive.
  await Hive.initFlutter();
  Hive.registerAdapter(NotificationLocalAdapter());
  await Hive.openBox<NotificationLocal>('notificationsBox');

  // Initialize Firebase.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize SharedPreferences.
  await Prefs.init();

  // Setup GetIt service locator.
  setupGetit();

  // Register FCM background handler.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize local notifications.
  await initializeLocalNotifications();

  // Request notification permissions (especially for iOS).
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Listen for foreground messages.
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Foreground message received: ${message.messageId}');
    showLocalNotification(message);
  });

  // Listen for when a notification opens the app.
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    log('Notification caused app to open: ${message.messageId}');
    // Optionally, handle navigation here.
  });

  // Run the app. (Registration of the FCM token to your backend will happen after login.)
  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
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
    );
  } else {
    runApp(
      BlocProvider(
        create: (context) => LocaleCubit(),
        child: const Deals(),
      ),
    );
  }
}

class Deals extends StatelessWidget {
  const Deals({Key? key}) : super(key: key);

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
