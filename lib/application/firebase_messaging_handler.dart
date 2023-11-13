import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingHandler {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void setListeners() {
    getToken();

    refreshToken();
  }

  void getToken() {
    firebaseMessaging.getToken().then((token) {
      print('DeviceToken = $token');
    });
  }

  void refreshToken() {
    firebaseMessaging.onTokenRefresh.listen((token) {});
  }

  void showDialog(BuildContext context, Map<String, dynamic> message) {
    // data
  }

  void showErrorDialog(BuildContext context, dynamic error) {
    // data
  }

  void redirectToPage(BuildContext context, Map<String, dynamic> message) {
    // data
  }
}
