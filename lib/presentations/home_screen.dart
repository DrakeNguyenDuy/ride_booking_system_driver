// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_booking_system_driver/application/google_service.dart';
import 'package:ride_booking_system_driver/application/main_service.dart';
import 'package:ride_booking_system_driver/application/message_service.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/constants/constants/dimension_constanst.dart';
import 'package:ride_booking_system_driver/core/style/button_style.dart';
import 'package:ride_booking_system_driver/core/style/main_style.dart';
import 'package:ride_booking_system_driver/core/utils/dialog_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  // static String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double zoom = 16.0;
  double price = 0;
  // late GoogleMapController mapController;
  // final Location _locationController = Location();
  GoogleService googleService = GoogleService();
  var controller = TextEditingController();
  bool isShowComplete = false;

  MainService mainService = MainService();

  Map<PolylineId, Polyline> polylinesMap = {};

  final _messagingService = MessageService();

  LatLng fixLocationDriver =
      const LatLng(10.763932849773887, 106.6817367439953);

  final Completer<GoogleMapController> _mapControllerCompleter =
      Completer<GoogleMapController>();

  void _onMapCreated(GoogleMapController controller) {
    // mapController = controller;
    _mapControllerCompleter.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _messagingService.init();
    }
    // if (_messagingService.getLatitudePick() != 0 &&
    //     _messagingService.getLongtitudePick() != 0 &&
    //     isShowComplete) {
    //   cameraToPosition(LatLng(_messagingService.getLatitudePick(),
    //       _messagingService.getLongtitudePick()));
    // }
  }

  //move camera to new position by position search
  Future<void> cameraToPosition(LatLng newPosition) async {
    final GoogleMapController controller = await _mapControllerCompleter.future;
    CameraPosition newCameraPosition =
        CameraPosition(target: newPosition, zoom: zoom);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId polylineId = const PolylineId("loylineid");
    Polyline polyline = Polyline(
        polylineId: polylineId,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylinesMap[polylineId] = polyline;
    });
  }

  void cancel() {
    Widget okButton = TextButton(
        style: ButtonStyleHandle.bts_1,
        onPressed: () {
          Navigator.pop(context);
          cancelRide();
        },
        child: const Text(
          "OK",
          style: TextStyle(color: ColorPalette.white),
        ));
    Widget cancelButton = TextButton(
      style: ButtonStyleHandle.bts_1,
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        "Hủy",
        style: TextStyle(color: ColorPalette.white),
      ),
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: "đas",
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Bạn vẫn muốn hủy xe chứ"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Nhập nội dung hủy chiến",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(ds_3)),
                  borderSide:
                      BorderSide(width: ds_0, color: ColorPalette.primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(ds_3)),
                  borderSide:
                      BorderSide(width: ds_0, color: ColorPalette.primaryColor),
                ),
              ),
              maxLines: 8,
            ),
            actions: [cancelButton, okButton],
            actionsAlignment: MainAxisAlignment.spaceEvenly,
          );
        });
  }

  Set<Marker> renderMarker() {
    if (_messagingService.getLatitudePick() != 0 &&
        _messagingService.getLongtitudePick() != 0 &&
        isShowComplete) {
      return {
        Marker(
          markerId: const MarkerId("location2"),
          position: LatLng(_messagingService.getLatitudePick(),
              _messagingService.getLongtitudePick()),
          icon: _messagingService.getMarker(),
        )
      };
    } else if (_messagingService.getLatitudePick() != 0 &&
        _messagingService.getLongtitudePick() != 0) {
      return {
        Marker(
          markerId: const MarkerId("location2"),
          position: fixLocationDriver,
          icon: BitmapDescriptor.defaultMarker,
        ),
        Marker(
          markerId: const MarkerId("location2"),
          position: LatLng(_messagingService.getLatitudePick(),
              _messagingService.getLongtitudePick()),
          icon: _messagingService.getMarker(),
        ),
      };
    } else {
      return {
        Marker(
          markerId: const MarkerId("location2"),
          position: fixLocationDriver,
          icon: BitmapDescriptor.defaultMarker,
        ),
      };
    }
  }

  void cancelRide() async {
    mainService
        .cancelRide(int.parse(_messagingService.getTripId()), controller.text)
        .then((res) async {
      if (res.statusCode == HttpStatus.ok) {
        // Navigator.pop(context);
        DialogUtils.showDialogNotfication(
            context, false, "Hủy chuyến thành công", Icons.done);
        _messagingService.reset();
        setState(() {
          isShowComplete = false;
        });
      } else {
        DialogUtils.showDialogNotfication(
            context, true, "Xảy ra lỗi khi hủy chuyến", Icons.error);
      }
    });
  }

  void pickCustomer() async {
    mainService.pickUpCustomer(_messagingService.getTripId()).then((res) async {
      final body = jsonDecode(res);
      String status = body["status"];
      if (status == "OK") {
        DialogUtils.showDialogNotfication(context, false,
            "Đã cập trạng thái sang đón khách", Icons.done_outline);
        openMap();
        setState(() {
          isShowComplete = true;
        });
      } else {
        DialogUtils.showDialogNotfication(
            context, true, "Đã xảy ra lỗi", Icons.error);
      }
    });
  }

  void completeTrip() async {
    mainService.conpleteTrip(_messagingService.getTripId()).then((res) async {
      final body = jsonDecode(res);
      String status = body["status"];
      if (status == "OK" && mounted) {
        DialogUtils.showDialogNotfication(
            context, false, "Đã hoàn thành chuyến", Icons.done_outline);
        _messagingService.reset();
        setState(() {
          isShowComplete = false;
        });
      } else {
        if (mounted) {
          DialogUtils.showDialogNotfication(
              context, true, "Đã xảy ra lỗi", Icons.error);
        }
      }
    });
  }

  Future<void> openMap() async {
    var uri = Uri.parse(
        "google.navigation:q=${_messagingService.getLatitudeDes()},${_messagingService.getLongtitudeDes()}&mode=d");
    // var uri = Uri.parse(
    //     "http://maps.google.com/maps?saddr=${_messagingService.getLatitudePick()},${_messagingService.getLongtitudePick()}&daddr=${_messagingService.getLatitudeDes()},${_messagingService.getLongtitudeDes()}&directionsmode=driving");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      DialogUtils.showDialogNotfication(
          context, true, "Không thể mở Google Map", Icons.error);
    }
  }

  Widget renderText(String nameLable, dynamic value) {
    return RichText(
      text: TextSpan(
        text: "$nameLable: ",
        style: MainStyle.textStyle2.copyWith(
          fontSize: 20,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
              text: "$value",
              style: MainStyle.textStyle2.copyWith(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      padding: const EdgeInsets.all(ds_1),
      height: MediaQuery.sizeOf(context).height / 2,
      decoration: BoxDecoration(
          color: ColorPalette.white,
          boxShadow: [
            BoxShadow(
                color: ColorPalette.primaryColor.withOpacity(0.2),
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 1)
          ],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          renderText("Mã chuyến đi", _messagingService.getTripId()),
          renderText("Điểm đón", _messagingService.getPick()),
          renderText("Điểm trả", _messagingService.getDes()),
          renderText(
              "Số điện thoại khách", _messagingService.getPhoneCustomer()),
          renderText("Gía", _messagingService.getPrice()),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 18,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.red,
                ),
                onPressed: cancel,
                child: Text(
                  "Hủy Chuyến",
                  style: MainStyle.textStyle5,
                ),
              )),
          isShowComplete
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 18,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                    ),
                    onPressed: completeTrip,
                    child: Text(
                      "Hoàn Thành Chuyến",
                      style: MainStyle.textStyle5,
                    ),
                  ))
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 18,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                    ),
                    onPressed: pickCustomer,
                    child: Text(
                      "Đón Khách",
                      style: MainStyle.textStyle5,
                    ),
                  ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _messagingService.getLatitudeDes() == 0 &&
                _messagingService.getLongtitudeDes() == 0
            ? null
            : bottomSheet(),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: fixLocationDriver,
            zoom: zoom,
          ),
          markers: renderMarker(),
          polylines: Set<Polyline>.of(polylinesMap.values),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    // mapController.dispose();
  }
}
