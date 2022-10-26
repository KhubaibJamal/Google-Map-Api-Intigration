import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.915872519970048, 67.09210289686517),
    zoom: 14.4746,
  );

  final List<Marker> _marker = [
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(24.915872519970048, 67.09210289686517),
      infoWindow: InfoWindow(
        title: "SSUET",
      ),
    ),
  ];

  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("Error: $error");
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getCurrentLocation().then((value) async {
            _marker.add(
              Marker(
                markerId: const MarkerId('2'),
                position: LatLng(value.latitude, value.longitude),
                infoWindow: const InfoWindow(
                  title: "My Current Location",
                ),
              ),
            );
            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 14.4746,
            );
            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
        },
        child: const Icon(
          Icons.my_location,
          size: 30.0,
        ),
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(_marker),
          mapType: MapType.normal,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }
}
