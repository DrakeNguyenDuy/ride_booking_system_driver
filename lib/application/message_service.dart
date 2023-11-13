import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_booking_system_driver/application/personal_service.dart';
import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:ride_booking_system_driver/core/style/main_style.dart';
import 'package:ride_booking_system_driver/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageService {
  static String? fcmToken; // Variable to store the FCM token

  static final MessageService _instance = MessageService._internal();

  factory MessageService() => _instance;

  PersonService personService = PersonService();

  MessageService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init(BuildContext context) async {
    // Requesting permission for notifications
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
        'User granted notifications permission: ${settings.authorizationStatus}');

    // Retrieving the FCM token
    fcmToken = await _fcm.getToken();

    // Handling background messages using the specified handler
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print(message);
    });

    // Listening for incoming messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        if (message.notification!.title != null &&
            message.notification!.body != null) {
          Map<String, dynamic> notificationData =
              jsonDecode(message.notification!.body!);
          showDialog(
            context: navigatorKey.currentContext!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  title: Text(message.notification!.title!),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: 'Mã chuyến đi: ',
                          style: MainStyle.textStyle2.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(
                              text: notificationData["Mã chuyến đi"],
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Điểm đón: ',
                          style: MainStyle.textStyle2.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(
                              text: notificationData["Điểm đón khách"],
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Điểm trả: ',
                          style: MainStyle.textStyle2.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(
                              text: notificationData["Điểm trả khách"],
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Gía: ',
                          style: MainStyle.textStyle2.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(
                              text: notificationData["Giá cuốc xe"],
                            ),
                            const TextSpan(
                              text: " VNĐ",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Từ chối"),
                    ),
                    TextButton(
                      onPressed: () {
                        accecpRide(int.parse(notificationData["Mã chuyến đi"]),
                            context);
                      },
                      child: const Text('Chấp nhận'),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    });

    // Handling the initial message received when the app is launched from dead (killed state)
    // When the app is killed and a new notification arrives when user clicks on it
    // It gets the data to which screen to open
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // _handleNotificationClick(context, message);
      }
    });

    // Handling a notification click event when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      // _handleNotificationClick(context, message);
    });
  }

  // Handling a notification click event by navigating to the specified screen
  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    final notificationData = message.data;

    if (notificationData.containsKey('screen')) {
      final screen = notificationData['screen'];
      Navigator.of(context).pushNamed(screen);
    }
  }

  void accecpRide(int tripId, BuildContext context) async {
    Navigator.of(context).pop();
    await SharedPreferences.getInstance().then((ins) {
      int idUser = ins.getInt(Varibales.DRIVER_ID)!;
      String tokenFirebase = ins.getString(Varibales.TOKEN_FIREBASE)!;
      personService
          .accecptRide(idUser, tokenFirebase, tripId)
          .then((res) async {
        if (res.statusCode == HttpStatus.ok) {
          Fluttertoast.showToast(
              msg: "Đã chấp nhận chuyến đi", webPosition: "top");
        } else {
          Fluttertoast.showToast(
              msg: "Xảy ra lỗi khi chấp nhận cuốc", webPosition: "top");
        }
      });
    });
  }

  // // Handler for background messages
  // @pragma('vm:entry-point')
  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   if (message.notification != null) {
  //     if (message.notification!.title != null &&
  //         message.notification!.body != null) {
  //       Map<String, dynamic> notificationData =
  //           jsonDecode(message.notification!.body!);
  //       showDialog(
  //         context: navigatorKey.currentContext!,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return WillPopScope(
  //             onWillPop: () async => false,
  //             child: AlertDialog(
  //               title: Text(message.notification!.title!),
  //               content: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   RichText(
  //                     textDirection: TextDirection.ltr,
  //                     textAlign: TextAlign.left,
  //                     text: TextSpan(
  //                       text: 'Mã chuyến đi: ',
  //                       style: MainStyle.textStyle2.copyWith(
  //                           fontWeight: FontWeight.bold, fontSize: 16),
  //                       children: <TextSpan>[
  //                         TextSpan(
  //                           text: notificationData["Mã chuyến đi"],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   RichText(
  //                     text: TextSpan(
  //                       text: 'Điểm đón: ',
  //                       style: MainStyle.textStyle2.copyWith(
  //                           fontWeight: FontWeight.bold, fontSize: 16),
  //                       children: <TextSpan>[
  //                         TextSpan(
  //                           text: notificationData["Điểm đón khách"],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   RichText(
  //                     text: TextSpan(
  //                       text: 'Điểm trả: ',
  //                       style: MainStyle.textStyle2.copyWith(
  //                           fontWeight: FontWeight.bold, fontSize: 16),
  //                       children: <TextSpan>[
  //                         TextSpan(
  //                           text: notificationData["Điểm trả khách"],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   RichText(
  //                     text: TextSpan(
  //                       text: 'Gía: ',
  //                       style: MainStyle.textStyle2.copyWith(
  //                           fontWeight: FontWeight.bold, fontSize: 16),
  //                       children: <TextSpan>[
  //                         TextSpan(
  //                           text: notificationData["Giá cuốc xe"],
  //                         ),
  //                         const TextSpan(
  //                           text: " VNĐ",
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text("Từ chối"),
  //                 ),
  //                 TextButton(
  //                   onPressed: () {
  //                     accecpRide(
  //                         int.parse(notificationData["Mã chuyến đi"]), context);
  //                   },
  //                   child: const Text('Chấp nhận'),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     }
  //   }
  // }
}
