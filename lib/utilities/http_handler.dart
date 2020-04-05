import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carpooling/requests/google_maps_requests.dart';

class HttpHandler {
  HttpHandler({this.url});
  String url;
  Future<void> testURL() async {
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    print(values.toString());
//    return values["routes"][0]["overview_polyline"]["points"];
    return;
  }

  Future distanceRequest(LatLng point1, LatLng point2) async{
            double lon1 = point1.longitude;
            double lat1 = point1.latitude;
            double lon2 = point2.longitude;
            double lat2 = point2.latitude;
    String api = apiKey;
    this.url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$lat1,$lon1&destinations=$lat2,$lon2&key=$api";
    http.Response response = await http.get(url);
    return response.body.toString();
  }
}
