// import 'package:firebase_messaging/';
// class FireBaseService {
//   Future<void> _getToken() async {
//    // You may set the permission requests to "provisional" which allows the user to choose what type
// // of notifications they would like to receive once the user receives a notification.
// final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);

// // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
// final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
// if (apnsToken != null) {
//  // APNS token is available, make FCM plugin API requests...
// }
//   }
// }
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _getToken() async {}
