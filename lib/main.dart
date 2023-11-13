import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ride_booking_system_driver/presentations/flash_screen.dart';
import 'package:ride_booking_system_driver/routes.dart';

late FirebaseMessaging messaging;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  runApp(const MyApp());
  // // await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp();
  // messaging = FirebaseMessaging.instance;
  // await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  // await messaging.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  // registerNotification();
}

// void registerNotification() async {
//   await Firebase.initializeApp();
//   final FirebaseMessaging messaging = FirebaseMessaging.instance;
//   messaging.setForegroundNotificationPresentationOptions(
//       alert: true, badge: true, sound: true);
//   messaging.getToken().then((value) async {
//     await SharedPreferences.getInstance().then((ins) {
//       ins.setString(Varibales.TOKEN_FIREBASE, value!);
//     });
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  // static var messageService =
  //     MessageService().init(navigatorKey.currentContext);

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
      navigatorKey: navigatorKey,
      supportedLocales: const [Locale("en"), Locale("vi")],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlashScreen(),
      routes: routes,
    );
  }
}
