import 'package:flutter/material.dart';
import 'package:ride_booking_system/presentations/flash_screen.dart';
import 'package:ride_booking_system/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  // await FlutterConfig.loadEnvVariables();
  runApp(const MyApp());
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
        // bottomSheetTheme: const BottomSheetThemeData(
        //   backgroundColor: ColorPalette.primaryColor,
        // ),
        primarySwatch: Colors.blue,
      ),
      home: const FlashScreen(),
      routes: routes,
    );
  }
}
