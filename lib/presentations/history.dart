import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/application/authentication_service.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  static const String routeName = "/history";

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
              Expanded(flex: 1, child: Text("History")),
            ],
          ),
        ));
  }
}
