import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carpooling/requests/google_maps_requests.dart';

class AppState with ChangeNotifier {
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  GoogleMapController _mapController;
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  bool locationServiceActive = true;

  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController; 
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polyLines;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};

  AppState() {
    _getUserLocation();
    _loadingInitialPosition();
  }

// TO GET THE USERS LOCATION FROM THE PHONE ITSELF
  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    _initialPosition = LatLng(position.latitude, position.longitude);
    locationController.text = placemark[0].name;
    notifyListeners();
  }

// TO CREATE AND DRAW THE ROUTE FROM ONE POINT TO THE OTHER
  void createRoute(String encodedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        points: _convertoLatLng(_decodePoly(encodedPoly)),
        width: 20,
        color: Colors.black));
  }

  // TO ADD MARKERS WHEN A LOCATION IS SET
  void _addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "destination"),
        icon: BitmapDescriptor.defaultMarker));
        notifyListeners();
  }

  // THIS METHOD WILL CONVERT DOUBLES INTO LATLNG IN ORDER TO USE THEM AS COORDINATES
  List<LatLng> _convertoLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

// THIS IS TO SEND REQUESTS TO THE GOOGLE MAPS API
  void sendRequest(String intendedLocation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    print(route.toString());
    createRoute(route);
    notifyListeners();
  }

// ON CAMERA MOVE
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  // ON GOOGLE MAPS CREATED
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }


  //  LOADING INITIAL POSITION
  void _loadingInitialPosition()async{
    await Future.delayed(Duration(seconds: 3)).then((v) {
      if(_initialPosition == null){
        locationServiceActive = false;
        notifyListeners();
      }
    });

}
}