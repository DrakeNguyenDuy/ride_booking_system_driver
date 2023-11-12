import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:ride_booking_system_driver/application/locator.dart';
import 'package:ride_booking_system_driver/application/navaigator_service.dart';
import 'package:ride_booking_system_driver/application/notification_service.dart';
import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:ride_booking_system_driver/presentations/flash_screen.dart';
import 'package:ride_booking_system_driver/routes.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _messageStreamController = BehaviorSubject<RemoteMessage>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.notification != null) {
    final body = jsonDecode(message.notification!.body as String);
    NotificationService notificationService = NotificationService();
    // notificationService.initializePlatformNotifications(context);
    String? title = message.notification!.title;
    // print(message.notification!.body);
    String bodyData =
        'Mã chuyến đi: ${body["Mã chuyến đi"]} \nĐiểm đón: ${body["Điêm đón khách"]}\nĐiểm đến: ${body["Điêm trả khách"]}\nGía: ${body["Giá cuốc xe"]}';
    // notificationService.showLocalNotification(
    //     id: 1, title: title!, body: bodyData, payload: bodyData);

    CallKitParams callKitParams = CallKitParams(
      id: '${body["Điêm đón khách"]}\n${body["Điêm trả khách"]}',
      nameCaller: 'Mã chiến đi ${body["Mã chiến đi"]}',
      appName: "RBS Driver",
      duration: 30000,
      // avatar: AssetImages.logo,
      handle: 'Mã chuyến đi: ${body["Mã chuyến đi"]}',
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        // isShowLogo: true,

        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'https://i.pravatar.cc/500',
        actionColor: 'red',
        // incomingCallNotificationChannelName: "Incoming Call",
        // missedCallNotificationChannelName: "Missed Call"
      ),
      textAccept: 'Nhận chuyến',
      textDecline: 'Từ chối',
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
    await FlutterCallkitIncoming.onEvent.listen((event) {
      listenerEvent(event!);
    });
  }
}

late FirebaseMessaging messaging;
final GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  runApp(const MyApp());
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
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Handling a foreground message: ${message.messageId}');
  //   print('Message data: ${message.data}');
  //   print('Message notification: ${message.notification?.title}');
  //   print('Message notification: ${message.notification?.body}');

  //   _messageStreamController.sink.add(message);
  // });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   Navigator.pushNamed(navigatorKey.currentContext!, '/accecpt-ride');
  // });
  // FirebaseMessaging.onMessage.listen(_firebaseMessagingRedirect);
  registerNotification();
}

Future<void> listenerEvent(CallEvent event) async {
  globalKey.currentState?.pushNamed("/login");
  try {
    FlutterCallkitIncoming.onEvent.listen((event) async {
      switch (event!.event) {
        case Event.actionCallIncoming:
          break;
        case Event.actionCallStart:
          break;
        case Event.actionCallAccept:
          Future.delayed(const Duration(milliseconds: 5000), () {
            globalKey.currentState?.pushNamed("/login");
          });
          // globalKey.currentState!.pushNamed("/login");
          print("Chấp nhận cuộc gọi");
          event.body;
          break;
        case Event.actionCallDecline:
          print("Từ chối cuộc gọi");
          break;
        case Event.actionCallEnded:
          break;
        case Event.actionCallTimeout:
          break;
        case Event.actionCallCallback:
          break;
        case Event.actionCallToggleHold:
          break;
        case Event.actionCallToggleMute:
          break;
        case Event.actionCallToggleDmtf:
          break;
        case Event.actionCallToggleGroup:
          // TODO: only iOS
          break;
        case Event.actionCallToggleAudioSession:
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
    // FirebaseMessaging.onBackgroundMessage(
    //     (message) => _firebaseMessagingBackgroundHandler(message, context));
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   Navigator.pushNamed(navigatorKey.currentContext!, '/accecpt-ride');
    // });
    // FirebaseMessaging.onMessage.listen(_firebaseMessagingRedirect);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      navigatorKey: globalKey,
      supportedLocales: const [Locale("en"), Locale("vi")],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlashScreen(),
      routes: routes,
    );
  }
}
