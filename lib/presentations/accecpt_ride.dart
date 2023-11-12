import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/application/authentication_service.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';

class AccecptRideScreen extends StatefulWidget {
  const AccecptRideScreen({super.key});
  static const String routeName = "/accecpt-ride";

  @override
  State<AccecptRideScreen> createState() => _AccecptRideScreenState();
}

class _AccecptRideScreenState extends State<AccecptRideScreen> {
  AuthenticationService authenticationService = AuthenticationService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorPalette.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 1, child: Text("Có")),
            ],
          ),
        ));
  }
}
