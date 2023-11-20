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
