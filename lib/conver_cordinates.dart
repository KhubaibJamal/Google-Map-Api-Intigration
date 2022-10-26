import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ConvertLatLagToAddress extends StatefulWidget {
  const ConvertLatLagToAddress({Key? key}) : super(key: key);

  @override
  State<ConvertLatLagToAddress> createState() => _ConvertLatLagToAddressState();
}

class _ConvertLatLagToAddressState extends State<ConvertLatLagToAddress> {
  String stAddress = '';
  String stAdd = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(stAddress),
          Text(stAdd),
          GestureDetector(
            onTap: () async {
              List<Location> locations = await locationFromAddress(
                  "Mashalla Apartment, Block G North Nazimabad Town, Karachi, Karachi City, Sindh, Pakistan");
              List<Placemark> placemaker = await placemarkFromCoordinates(
                  24.934727873509004, 67.0443945815216);

              setState(() {
                stAddress =
                    "${locations.last.latitude} ${locations.last.longitude}";
                stAdd =
                    "${placemaker.reversed.last.country} ${placemaker.reversed.last.locality}";
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: const Center(
                  child: Text("Convert"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
