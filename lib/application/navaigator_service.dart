import 'package:flutter/material.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String route) {
    return globalKey.currentState!.pushNamed(route);
  }

  void goBack() {
    return globalKey.currentState!.pop();
  }
}
