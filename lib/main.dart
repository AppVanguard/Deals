import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'apple_sign_in.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage msg) async {
  await Firebase.initializeApp();
  print('\uD83D\uDCA4 Background msg: ${msg.messageId}');
}

void configureFCM() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);
  FirebaseMessaging.onMessage.listen((m) => print('Foreground msg: ${m.notification?.title}'));
  FirebaseMessaging.instance.getToken().then((t) => print('FCM token: $t'));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureFCM();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Deals')),
        body: const Center(
          child: ElevatedButton(
            onPressed: signInWithApple,
            child: Text('Sign in with Apple'),
          ),
        ),
      ),
    );
  }
}
