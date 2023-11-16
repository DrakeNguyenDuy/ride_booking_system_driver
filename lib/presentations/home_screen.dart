import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ride_booking_system_driver/application/firebase_messaging_handler.dart';
import 'package:ride_booking_system_driver/application/google_service.dart';
import 'package:ride_booking_system_driver/application/message_service.dart';

class HomeScreen extends StatefulWidget {
  // static String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _fcm = FirebaseMessagingHandler();
  // late final FirebaseMessaging _messaging;
  final double zoom = 18.0;
  double price = 0;
  late GoogleMapController mapController;
  final Location _locationController = Location();
  GoogleService googleService = GoogleService();

  Map<PolylineId, Polyline> polylinesMap = {};

  final _messagingService = MessageService();

  LatLng fixLocationDriver =
      const LatLng(10.763932849773887, 106.6817367439953);
  LatLng l2 = LatLng(10.764032849773887, 106.6818367439953);

  final Completer<GoogleMapController> _mapControllerCompleter =
      Completer<GoogleMapController>();

  void _onMapCreated(GoogleMapController controller) {
    // mapController = controller;
    _mapControllerCompleter.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    _messagingService.init(context);
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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

  Set<Marker> renderMarker() {
    if (_messagingService.getLatitudeDes() != 0 &&
        _messagingService.getLongtitudeDes() != 0) {
      return {
        Marker(
          markerId: const MarkerId("location2"),
          position: fixLocationDriver,
          icon: BitmapDescriptor.defaultMarker,
        ),
        Marker(
          markerId: const MarkerId("location2"),
          position: LatLng(_messagingService.getLatitudeDes(),
              _messagingService.getLongtitudeDes()),
          icon: BitmapDescriptor.defaultMarker,
        )
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: fixLocationDriver,
            zoom: zoom,
          ),
          markers: renderMarker(),
          // markers: {
          //   Marker(
          //     markerId: const MarkerId("location2"),
          //     position: fixLocationDriver,
          //     icon: BitmapDescriptor.defaultMarker,
          //   ),
          //   Marker(
          //     markerId: const MarkerId("location2"),
          //     position: l2,
          //     icon: BitmapDescriptor.defaultMarker,
          //   )
          // },
          polylines: Set<Polyline>.of(polylinesMap.values),
        ),
      ),
    );
  }
}
