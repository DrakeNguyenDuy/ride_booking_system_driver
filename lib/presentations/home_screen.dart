import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ride_booking_system_driver/application/google_service.dart';

class HomeScreen extends StatefulWidget {
  // static String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late final FirebaseMessaging _messaging;
  final double zoom = 18.0;
  double price = 0;
  late GoogleMapController mapController;
  final Location _locationController = Location();
  GoogleService googleService = GoogleService();

  Map<PolylineId, Polyline> polylinesMap = {};

  LatLng fixLocationDriver =
      const LatLng(10.763932849773887, 106.6817367439953);
  LatLng l2 = LatLng(10.878, 106.757);

  final Completer<GoogleMapController> _mapControllerCompleter =
      Completer<GoogleMapController>();

  void _onMapCreated(GoogleMapController controller) {
    // mapController = controller;
    _mapControllerCompleter.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    // registerNotification();
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
          markers: {
            Marker(
              markerId: const MarkerId("location2"),
              position: fixLocationDriver,
              icon: BitmapDescriptor.defaultMarker,
            ),
            Marker(
              markerId: const MarkerId("location1"),
              position: l2,
              icon: BitmapDescriptor.defaultMarkerWithHue(2),
            ),
          },
          polylines: Set<Polyline>.of(polylinesMap.values),
        ),
      ),
    );
  }

  void registerNotification() async {
    // await Firebase.initializeApp();
    // // 2. Instantiate Firebase Messaging
    // _messaging = FirebaseMessaging.instance;
    // _messaging.getToken().then((value) async {
    //   await SharedPreferences.getInstance().then((ins) {
    //     ins.setString(Varibales.TOKEN_FIREBASE, value!);
    //   });
    // });
    // // FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
    // //   print(remoteMessage.data);
    // // });
  }
}
