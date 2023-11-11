import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_booking_system_driver/application/notification_service.dart';
import 'package:ride_booking_system_driver/core/constants/constants/assets_images.dart';
import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:ride_booking_system_driver/presentations/flash_screen.dart';
import 'package:ride_booking_system_driver/routes.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _messageStreamController = BehaviorSubject<RemoteMessage>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.notification != null) {
    final body = jsonDecode(message.notification!.body as String);
    NotificationService notificationService = NotificationService();
    notificationService.initializePlatformNotifications();
    notificationService.showLocalNotification(
        id: 1, title: "dsdsadas", body: "đasad", payload: "sdsdas");

    // CallKitParams callKitParams = CallKitParams(
    //   id: body["Mã chuyến đi"],
    //   nameCaller: "${message.notification!.title}",
    //   appName: "RBS Driver",
    //   duration: 30000,
    //   // avatar: AssetImages.logo,
    //   extra: <String, dynamic>{'userId': '1a2b3c4d'},
    //   headers: <String, dynamic>{'name': 'Abc@123!', 'des': 'flutter'},
    //   handle: 'Mã chuyến đi: ${body["Mã chuyến đi"]}',
    //   android: const AndroidParams(
    //       isCustomNotification: true,
    //       isShowLogo: true,
    //       ringtonePath: 'system_ringtone_default',
    //       backgroundColor: '#0955fa',
    //       backgroundUrl: 'https://i.pravatar.cc/500',
    //       actionColor: '#4CAF50',
    //       incomingCallNotificationChannelName: "Incoming Call",
    //       missedCallNotificationChannelName: "Missed Call"),
    //   textAccept: 'Nhận chuyến',
    //   textDecline: 'Từ chối',
    // );
    // await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
    // await FlutterCallkitIncoming.onEvent.listen((event) {
    //   listenerEvent(event!);
    // });
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

Future<void> listenerEvent(CallEvent event) async {
  try {
    FlutterCallkitIncoming.onEvent.listen((event) async {
      print('HOME: $event');
      switch (event!.event) {
        case Event.actionCallIncoming:
          // TODO: received an incoming call
          break;
        case Event.actionCallStart:
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          break;
        case Event.actionCallAccept:
          print("Chấp nhận cuộc gọi");
          break;
        case Event.actionCallDecline:
          print("Từ chối cuộc gọi");
          break;
        case Event.actionCallEnded:
          // TODO: ended an incoming/outgoing call
          break;
        case Event.actionCallTimeout:
          // TODO: missed an incoming call
          break;
        case Event.actionCallCallback:
          // TODO: only Android - click action `Call back` from missed call notification
          break;
        case Event.actionCallToggleHold:
          // TODO: only iOS
          break;
        case Event.actionCallToggleMute:
          // TODO: only iOS
          break;
        case Event.actionCallToggleDmtf:
          // TODO: only iOS
          break;
        case Event.actionCallToggleGroup:
          // TODO: only iOS
          break;
        case Event.actionCallToggleAudioSession:
          // TODO: only iOS
          break;
        case Event.actionDidUpdateDevicePushTokenVoip:
          // TODO: only iOS
          break;
        case Event.actionCallCustom:
          break;
      }
    });
  } on Exception catch (e) {
    print(e);
  }
}

void registerNotification() async {
  await Firebase.initializeApp();
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
