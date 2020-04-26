import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'http_handler.dart';

HttpHandler handler = new HttpHandler();

String distance(LatLng point1, LatLng point2) {
  double lon1 = point1.longitude;
  double lat1 = point1.latitude;
  double lon2 = point2.longitude;
  double lat2 = point2.latitude;
  double theta = lon1 - lon2;
  double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
      cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
  dist = acos(dist);
  dist = rad2deg(dist);
  dist = dist * 60 * 1.1515;
  // if (unit == 'K') {
  dist = dist * 1.609344;
  // } else if (unit == 'N') {
  //   dist = dist * 0.8684;
  // }
  return dist.toStringAsFixed(2);
}

double deg2rad(double deg) {
  return (deg * pi / 180.0);
}

double rad2deg(double rad) {
  return (rad * 180.0 / pi);
}
