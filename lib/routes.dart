import 'package:flutter/cupertino.dart';
import 'package:ride_booking_system/presentations/login.dart';
import 'package:ride_booking_system/presentations/main_app.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => const LoginScreen(),
  MainApp.routeName: (context) => const MainApp(),
};
