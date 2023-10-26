import 'package:flutter/material.dart';
import 'package:ride_booking_system/application/authentication_service.dart';
import 'package:ride_booking_system/core/constants/constants/color_constants.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  static const String routeName = "/wallet";

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
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
              Expanded(flex: 1, child: Text("Wallet")),
            ],
          ),
        ));
  }
}
