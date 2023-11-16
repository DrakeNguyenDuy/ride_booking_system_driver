import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/core/widgets/bottom_bar.dart';
import 'package:ride_booking_system_driver/presentations/history.dart';
import 'package:ride_booking_system_driver/presentations/home_screen.dart';
import 'package:ride_booking_system_driver/presentations/personal.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  static String routeName = "/home";
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  int _currentIndex = 0;
  void moveStack(int index, String namScreen) {
    setState(() {
      _currentIndex = index;
    });
  }

  final listScreen = [
    const HomeScreen(),
    const HistoryScreen(),
    const PersonalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
          transitionBuilder: AnimatedSwitcher.defaultTransitionBuilder,
          duration: const Duration(milliseconds: 0),
          child: listScreen[_currentIndex]),
      bottomNavigationBar: BottomBar(
          indexCurrentParameter: _currentIndex,
          moveStack: (index, nameScreen) => moveStack(index, nameScreen)),
    );
  }
}
