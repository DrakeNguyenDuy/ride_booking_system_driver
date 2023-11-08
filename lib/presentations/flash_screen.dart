import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:ride_booking_system_driver/core/widgets/loading.dart';
import 'package:ride_booking_system_driver/presentations/login.dart';
import 'package:ride_booking_system_driver/presentations/main_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({Key? key}) : super(key: key);
  static String routeName = "/flash_screen";

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    super.initState();
    redirectToIntro();
  }

  void redirectToIntro() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? accessToken = sp.getString(Varibales.ACCESS_TOKEN);
    // await Future.delayed(const Duration(seconds: 2));
    if (accessToken == null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const MainApp()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingWidget(),
    );
  }
}
