import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ride_booking_system_driver/application/personal_service.dart';
import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() => _instance;

  LocationService._internal();

  final Location _locationController = Location();

  LatLng? _currentLocation;

  static final PersonService _personalService = PersonService();

  late IOWebSocketChannel channel;

  Timer? timer;

  Future<void> getLocation(Function callback) async {
    bool serviceEnable;
    PermissionStatus permissionGranted;
    serviceEnable = await _locationController.serviceEnabled();
    if (serviceEnable) {
      serviceEnable = await _locationController.requestService();
    } else {
      return;
    }
    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.longitude != null &&
          currentLocation.latitude != null) {
        callback();
        _currentLocation =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      }
    });
  }

  void connect(int idUser, String tokenFirebase) async {
    _personalService.connect(idUser).then((res) async {
      if (res.statusCode == HttpStatus.ok) {
        await connectSocket();
        streamBase(idUser, tokenFirebase);
        Fluttertoast.showToast(
            msg: "Kết nối thành công", webPosition: "bottom");
        timer = Timer.periodic(const Duration(seconds: 15),
            (Timer t) => streamBase(idUser, tokenFirebase));
      } else {
        Fluttertoast.showToast(msg: "Đã xảy ra lỗi", webPosition: "bottom");
      }
    });
    // listenStream();
    changeStateConnect(true);
  }

  void changeStateConnect(bool status) async {
    await SharedPreferences.getInstance().then((ins) {
      ins.setBool(Varibales.IS_CONNECT, status);
    });
  }

  void disconnect(int idUser) async {
    _personalService.disconnect(idUser).then((res) async {
      if (res.statusCode == HttpStatus.ok) {
        Fluttertoast.showToast(
            msg: "Đóng kết nối thành công", webPosition: "bottom");
        // channel.closeCode;
        if (timer != null) {
          timer!.cancel();
        }
      } else {
        Fluttertoast.showToast(msg: "Đã xảy ra lỗi", webPosition: "bottom");
      }
    });
    changeStateConnect(false);
  }

  Future connectSocket() async {
    channel = IOWebSocketChannel.connect(
      Uri.parse('ws://ridebookingsystem.ddns.net:9090/socketHandler'),
    );
  }

  Future streamBase(int idUser, String tokenFirebase) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    channel.sink.add(
        '{"userId": $idUser, "latitude": ${_currentLocation!.latitude}, "longitude": ${_currentLocation!.longitude}, "token": "$tokenFirebase", "timestamp":$timeStamp}');
    // channel.stream.listen((message) {
    //   print('Received: $message');
    // });
    // Future.delayed(const Duration(seconds: 5));
  }

  Future listenStream() async {
    channel.stream.listen((message) {
      print('Received: $message');
    });
  }

  LatLng? getCurrentLocation() => _currentLocation;
}
