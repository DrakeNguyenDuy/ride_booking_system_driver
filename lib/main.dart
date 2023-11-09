import 'dart:js';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:ride_booking_system_driver/presentations/accecpt_ride.dart';
import 'package:ride_booking_system_driver/presentations/flash_screen.dart';
import 'package:ride_booking_system_driver/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

final _messageStreamController = BehaviorSubject<RemoteMessage>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.notification != null) {
    print("Handling a background message: ${message.notification!.title}");
    print("Handling a background message: ${message.notification!.body}");
    Navigator.pushAndRemoveUntil(
        context as BuildContext,
        MaterialPageRoute(builder: (_) => const AccecptRideScreen()),
        (route) => false);
  }
}

late FirebaseMessaging messaging;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  // await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp();
  messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Handling a foreground message: ${message.messageId}');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');

    _messageStreamController.sink.add(message);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  registerNotification();
  runApp(const MyApp());
}

void registerNotification() async {
  await Firebase.initializeApp();
  // 2. Instantiate Firebase Messaging
  late final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  _messaging.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  _messaging.getToken().then((value) async {
    await SharedPreferences.getInstance().then((ins) {
      ins.setString(Varibales.TOKEN_FIREBASE, value!);
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.

  @override
  MaterialApp build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale("en"), Locale("vi")],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlashScreen(),
      routes: routes,
    );
  }
}
