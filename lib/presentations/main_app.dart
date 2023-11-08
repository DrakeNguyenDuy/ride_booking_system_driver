import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/core/widgets/bottom_bar.dart';
import 'package:ride_booking_system_driver/presentations/history.dart';
import 'package:ride_booking_system_driver/presentations/home_screen.dart';
import 'package:ride_booking_system_driver/presentations/personal.dart';
import 'package:ride_booking_system_driver/presentations/wallet.dart';

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
    // redirectToIntro();
  }

  int _currentIndex = 0;
  String _nameScreen = '';
  void moveStack(int index, String namScreen) {
    setState(() {
      _nameScreen = namScreen;
      _currentIndex = index;
    });
  }

  // void redirectToIntro() async {
  //   final SharedPreferences sp = await SharedPreferences.getInstance();
  //   sp.clear();
  // }

  final listScreen = [
    const HomeScreen(),
    const HistoryScreen(),
    const WalletScreen(),
    const PersonalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _currentIndex != 2
      //     ? AppBar(
      //         systemOverlayStyle: const SystemUiOverlayStyle(
      //             statusBarColor: Colors.transparent),
      //         leading: const Icon(
      //           Icons.chevron_left,
      //           size: sizeIcon_1,
      //           color: ColorPalette.primaryColor,
      //         ),
      //         title: Text(
      //           _nameScreen,
      //           style: TextStyleApp.tsHeader,
      //         ),
      //         backgroundColor: ColorPalette.white)
      //     : null,
      body: AnimatedSwitcher(
          transitionBuilder: AnimatedSwitcher.defaultTransitionBuilder,
          // switchInCurve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 0),
          child: listScreen[_currentIndex]),
      bottomNavigationBar: BottomBar(
          indexCurrentParameter: _currentIndex,
          moveStack: (index, nameScreen) => moveStack(index, nameScreen)),
    );
  }
}
// IndexedStack(
//           index: _currentIndex,
//           key: ValueKey<int>(_currentIndex),
//           children: const [
//             NewsFeedScreen(),
//             TaskScreen(),
//             HomeScreen(),
//             ProposalScreen(),
//             PersonalScreen()
//           ],
//         ),
