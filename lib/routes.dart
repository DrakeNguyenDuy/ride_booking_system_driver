import 'package:flutter/cupertino.dart';
import 'package:ride_booking_system_driver/presentations/accecpt_ride.dart';
import 'package:ride_booking_system_driver/presentations/login.dart';
import 'package:ride_booking_system_driver/presentations/main_app.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => const LoginScreen(),
  MainApp.routeName: (context) => const MainApp(),
  AccecptRideScreen.routeName: (context) => const AccecptRideScreen(),
};
