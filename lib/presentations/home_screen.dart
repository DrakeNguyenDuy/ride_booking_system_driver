import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ride_booking_system/application/common.config.dart';
import 'package:ride_booking_system/core/widgets/loading.dart';

class HomeScreen extends StatefulWidget {
  // static String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double zoom = 17.0;
  late GoogleMapController mapController;
  final Location _locationController = Location();

  Map<PolylineId, Polyline> polylinesMap = {};

  LatLng? _currentLocation;

  LatLng l1 = LatLng(10.868, 106.751);
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
    getLocation().then((_) => getPolyPoint()
        .then((coordinates) => {generatePolylineFromPoints(coordinates)}));
  }

  Future<void> getLocation() async {
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
        setState(() {
          _currentLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          cameraToPosition(l1);
        });
      }
    });
  }

  Future<List<LatLng>> getPolyPoint() async {
    List<LatLng> polyPointCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
            CommonConfig.API_GOOGLE_KEY,
            PointLatLng(l1.latitude, l1.longitude),
            PointLatLng(l2.latitude, l2.longitude),
            travelMode: TravelMode.driving);
    if (polylineResult.points.isNotEmpty) {
      for (var element in polylineResult.points) {
        polyPointCoordinates.add(LatLng(element.latitude, element.longitude));
      }
    } else {
      print(polylineResult.errorMessage);
    }
    return polyPointCoordinates;
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
    PolylineId polylineId = PolylineId("d");
    Polyline polyline = Polyline(
        polylineId: polylineId,
        color: Colors.black,
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
        body: _currentLocation == null
            ? const LoadingWidget()
            : GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentLocation!,
                  zoom: zoom,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId("location2"),
                    position: l1,
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
}
