import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_booking_system_driver/application/personal_service.dart';
import 'package:ride_booking_system_driver/core/constants/constants/assets_images.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:ride_booking_system_driver/core/style/button_style.dart';
import 'package:ride_booking_system_driver/core/style/main_style.dart';
import 'package:ride_booking_system_driver/core/utils/dialog_utils.dart';
import 'package:ride_booking_system_driver/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageService {
  static String? fcmToken; // Variable to store the FCM token

  late BitmapDescriptor myIcon;
  static double latitudeDes = 0;
  static double longtitudeDes = 0;
  static double latitudePick = 0;
  static double longtitudePick = 0;

  static String titleCancelRide = "Chuyến đi đã bị hủy bởi khách hàng!";
  static String titleNewRide = "Bạn nhận được một cuốc xe mới!";
  static String titleRating = "Khách hàng có 1 đánh giá cho bạn!";

  static String pick = "";
  static String des = "";
  static String phoneCustomer = "";
  static String tripId = "";
  static String priceTrip = "";

  static final MessageService _instance = MessageService._internal();

  factory MessageService() => _instance;

  PersonService personService = PersonService();

  MessageService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
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

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), AssetImages.markerIc)
        .then((onValue) {
      myIcon = onValue;
    });

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
          String? title = message.notification!.title;
          if (title == titleCancelRide) {
            showDialogCancelRide(title!, message.notification!.body);
          } else if (title == titleRating) {
            showDialogRated(title!, message.notification!.body);
          } else if (title == titleNewRide) {
            showDialogNewRide(title!, message.notification!.body);
          }
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

  void accecpRide(int tripId) async {
    await SharedPreferences.getInstance().then((ins) {
      Navigator.of(navigatorKey.currentContext!).pop();
      int idUser = ins.getInt(Varibales.DRIVER_ID)!;
      String tokenFirebase = ins.getString(Varibales.TOKEN_FIREBASE)!;
      personService
          .accecptRide(idUser, tokenFirebase, tripId)
          .then((res) async {
        if (res.statusCode == HttpStatus.ok) {
          Navigator.of(navigatorKey.currentContext!).pushNamed("/home");
        } else {
          DialogUtils.showDialogNotfication(navigatorKey.currentContext!, true,
              "Xảy ra lỗi khi nhận chuyến đi", Icons.error_outline);
        }
      });
    });
  }

  void showDialogNewRide(String title, dynamic body) {
    Map<String, dynamic> notificationData = jsonDecode(body);
    latitudeDes = double.parse(notificationData["Vĩ độ điểm đến"]);
    longtitudeDes = double.parse(notificationData["Kinh độ điểm đến"]);
    latitudePick = double.parse(notificationData["Vĩ độ điểm đón"]);
    longtitudePick = double.parse(notificationData["Kinh độ điểm đón"]);
    tripId = notificationData["Mã chuyến đi"];
    pick = notificationData["Điểm đón khách"];
    des = notificationData["Điểm trả khách"];
    priceTrip = notificationData["Giá cuốc xe"];
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
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
                          text: tripId,
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
                          text: pick,
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
                        text: des,
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
                          text: priceTrip,
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
                  Navigator.pop(context);
                },
                child: const Text(
                  "Từ chối",
                  style: TextStyle(color: ColorPalette.white),
                ),
              ),
              TextButton(
                style: ButtonStyleHandle.bts_1,
                onPressed: () {
                  accecpRide(int.parse(tripId));
                },
                child: const Text('Chấp nhận',
                    style: TextStyle(color: ColorPalette.white)),
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

  void showDialogCancelRide(String title, dynamic body) {
    Map<String, dynamic> notificationData = jsonDecode(body);
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
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
                    text: 'Lý do: ',
                    style: MainStyle.textStyle2.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: notificationData["Lý do hủy cuốc"],
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
                  reset();
                  Navigator.of(context).pushNamed("/home");
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: ColorPalette.white),
                ),
              ),
            ],
            icon: const Icon(Icons.notification_important,
                size: 50, color: ColorPalette.primaryColor),
            actionsAlignment: MainAxisAlignment.spaceAround,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
          ),
        );
      },
    );
  }

  void showDialogRated(String title, dynamic body) {
    Map<String, dynamic> notificationData = jsonDecode(body);
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
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
                    text: 'Số sao đánh giá: ',
                    style: MainStyle.textStyle2.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: notificationData["Đánh giá"],
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
                  reset();
                  Navigator.of(context).pushNamed("/home");
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: ColorPalette.white),
                ),
              ),
            ],
            icon: const Icon(Icons.stars_outlined,
                size: 50, color: ColorPalette.primaryColor),
            actionsAlignment: MainAxisAlignment.spaceAround,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
          ),
        );
      },
    );
  }

  double getLatitudeDes() => latitudeDes;
  double getLongtitudeDes() => longtitudeDes;
  double getLatitudePick() => latitudePick;
  double getLongtitudePick() => longtitudePick;

  String getTripId() => tripId;
  String getDes() => des;
  String getPick() => pick;
  String getPrice() => priceTrip;

  BitmapDescriptor getMarker() => myIcon;

  void reset() {
    latitudeDes = 0;
    longtitudeDes = 0;
    latitudePick = 0;
    longtitudePick = 0;
  }
}
