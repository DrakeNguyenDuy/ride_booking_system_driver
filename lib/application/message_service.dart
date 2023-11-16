import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/application/personal_service.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:ride_booking_system_driver/core/style/button_style.dart';
import 'package:ride_booking_system_driver/core/style/main_style.dart';
import 'package:ride_booking_system_driver/core/style/text_style.dart';
import 'package:ride_booking_system_driver/core/utils/dialog_utils.dart';
import 'package:ride_booking_system_driver/main.dart';
import 'package:ride_booking_system_driver/presentations/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageService {
  static String? fcmToken; // Variable to store the FCM token

  static double latitudeDes = 0;
  static double longtitudeDes = 0;

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
    // fcmToken = await _fcm.getToken();
    await _fcm.getToken().then((value) async {
      await SharedPreferences.getInstance().then((ins) {
        ins.setString(Varibales.TOKEN_FIREBASE, value!);
      });
    });

    // Handling background messages using the specified handler
    // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    //   print(message);
    // });

    // Listening for incoming messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        if (message.notification!.title != null &&
            message.notification!.body != null) {
          Map<String, dynamic> notificationData =
              jsonDecode(message.notification!.body!);
          latitudeDes = double.parse(notificationData["Vĩ độ điểm đến"]);
          longtitudeDes = double.parse(notificationData["Kinh độ điểm đến"]);
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
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: notificationData["Mã chuyến đi"],
                                style: MainStyle.textStyle2.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Điểm đón: ',
                          style: MainStyle.textStyle2.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: notificationData["Điểm đón khách"],
                                style: MainStyle.textStyle2.copyWith(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Điểm trả: ',
                          style: MainStyle.textStyle2.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: notificationData["Điểm trả khách"],
                              style: MainStyle.textStyle2.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Gía: ',
                          style: MainStyle.textStyle2.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: notificationData["Giá cuốc xe"],
                                style: MainStyle.textStyle2.copyWith(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal)),
                            TextSpan(
                                text: " VNĐ",
                                style: MainStyle.textStyle2.copyWith(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      style: ButtonStyleHandle.bts_1,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Từ chối",
                      ),
                    ),
                    TextButton(
                      style: ButtonStyleHandle.bts_1,
                      onPressed: () {
                        accecpRide(int.parse(notificationData["Mã chuyến đi"]),
                            context);
                      },
                      child: Text(
                        'Chấp nhận',
                      ),
                    ),
                  ],
                  icon: const Icon(Icons.directions_car_rounded,
                      size: 50, color: ColorPalette.primaryColor),
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
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
          // DialogUtils.showDialogNotfication(
          //     context, "Chấp nhận cuốc thành công", Icons.done);
        } else {
          // DialogUtils.showDialogNotfication(
          //     context, "Xảy ra lỗi khi nhận thành công", Icons.error_outline);
        }
      });
    });
  }

  double getLatitudeDes() => latitudeDes;
  double getLongtitudeDes() => longtitudeDes;
}
