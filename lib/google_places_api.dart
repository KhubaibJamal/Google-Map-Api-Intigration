import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class GoogleMapPlacesApi extends StatefulWidget {
  const GoogleMapPlacesApi({Key? key}) : super(key: key);

  @override
  State<GoogleMapPlacesApi> createState() => _GoogleMapPlacesApiState();
}

class _GoogleMapPlacesApiState extends State<GoogleMapPlacesApi> {
  TextEditingController searchController = TextEditingController();

  var uuid = Uuid();
  String sessionToken = '12345';
  List<dynamic> placesList = [''];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (sessionToken == null) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }
    getSuggestion(searchController.text);
  }

  void getSuggestion(String input) async {
    String api_key = 'AIzaSyAEuz1fejzXNChiLj21pPof6e8NhmM2Xss';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$api_key&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();

    print("data");
    print(data);
    if (response.statusCode == 200) {
      setState(() {
        placesList = jsonDecode(response.body.toString())['prediction'];
      });
    } else {
      throw Exception("Failed to load");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map Places API"),
        centerTitle: true,
      ),
      body: Padding(
        // padding: const EdgeInsets.symmetric(vertical: 12.0),
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search Places Here",
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: placesList.length,
            //     itemBuilder: ((context, index) {
            //       return ListTile(
            //         title: Text(placesList[index]['description']),
            //       );
            //     }),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
