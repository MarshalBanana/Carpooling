import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
}
