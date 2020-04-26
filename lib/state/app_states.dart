import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carpooling/requests/google_maps_requests.dart';
import 'package:google_maps_webservice/places.dart';

class AppState with ChangeNotifier {
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  LatLng _pickupPosition = _initialPosition;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  GoogleMapController _mapController;
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  bool locationServiceActive = true;
  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: "AIzaSyAS6yFOpTAblkIYrYIxKsFpRP9caH58MYc");
  Prediction prediction;
  Prediction pickupPrediction;

  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  LatLng get pickupPosition => _pickupPosition;
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polyLines;
  GoogleMapsPlaces get places => _places;
  Set<Marker> _markers = {};
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

  Future<LatLng> getCurrentLocation() async {
    Position p = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return LatLng(p.latitude, p.longitude);
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
        markerId: MarkerId(location.toString()),
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
  // void sendRequest(String intendedLocation) async {
  //   List<Placemark> placemark =
  //       await Geolocator().placemarkFromAddress(intendedLocation);
  //   double latitude = placemark[0].position.latitude;
  //   double longitude = placemark[0].position.longitude;
  //   LatLng destination = LatLng(latitude, longitude);
  //   _addMarker(destination, intendedLocation);
  //   String route = await _googleMapsServices.getRouteCoordinates(
  //       _initialPosition, destination);
  //   print(route.toString());
  //   createRoute(route);
  //   notifyListeners();
  // }
  void sendRequest(String userDistenation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(userDistenation);
    print(placemark.toString());
    // double latitude = placemark[0].position.latitude;
    // double longitude = placemark[0].position.longitude;
    // LatLng destination = LatLng(latitude, longitude);

    // get detail (lat/lng)
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId);
    print(detail.toString());
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;
    LatLng destination = LatLng(lat, lng);
    _lastPosition = destination;
    _addMarker(destination, userDistenation);
    _addMarker(destination, userDistenation);
    // String route = await _googleMapsServices.getRouteCoordinates(
    //     initialPosition, destination);
    // print("$lat,$lng");
    // createRoute(route);
    notifyListeners();
  }

  void sendRequestPickup(String userPickup) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(userPickup);
    print(placemark.toString());
    // double latitude = placemark[0].position.latitude;
    // double longitude = placemark[0].position.longitude;
    // LatLng destination = LatLng(latitude, longitude);

    // get detail (lat/lng)
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId);
    print(detail.toString());
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;
    LatLng pickup = LatLng(lat, lng);
    _pickupPosition = pickup;
    _addMarker(pickup, userPickup);
    _addMarker(pickup, userPickup);
    // String route = await _googleMapsServices.getRouteCoordinates(
    //     initialPosition, destination);
    // print("$lat,$lng");
    // createRoute(route);
    notifyListeners();
  }

// CLEAR MARKERS
  void clearMarkers() {
    _markers = {};
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

  // This is for displaying the ride information on the map of the ride info screen ie. begin, end, and route between them
  void onCreatedRideInfo(LatLng initial, LatLng destination) async {
    // markers.remove(markers.last);
    _markers = {};
    _addMarker(initial, "initial");
    _addMarker(destination, "destination");
    // print("*"*80);
    // print("*"*80);
    // print("*"*80);
    // print("*"*80);
    // String route = await _googleMapsServices.getRouteCoordinates(
    //       initialPosition, destination);
    //print("$lat,$lng");
    //createRoute(route);
    notifyListeners();
  }

  //  LOADING INITIAL POSITION
  void _loadingInitialPosition() async {
    await Future.delayed(Duration(seconds: 3)).then((v) {
      if (_initialPosition == null) {
        locationServiceActive = false;
        notifyListeners();
      }
    });
  }

  void displayPrediction(Prediction prediction) async {
    if (prediction != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(prediction.placeId);

      var placeId = prediction.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      LatLng place = LatLng(lat, lng);
      var address =
          await Geocoder.local.findAddressesFromQuery(prediction.description);
      print(address);
      _addMarker(place, "place");
      print(lat);
      print(lng);
      notifyListeners();
    }
  }

  Future<void> getOLocationAutoCOmplete(BuildContext context) async {
    prediction = await PlacesAutocomplete.show(
        context: context,
        apiKey: apiKey,
        mode: Mode.overlay, // Mode.fullscreen
        language: "en",
        components: [new Component(Component.country, "sa")]);

    destinationController.text = prediction.description;
    notifyListeners();
  }

  Future<void> getOLocationAutoCompletePickup(BuildContext context) async {
    pickupPrediction = await PlacesAutocomplete.show(
        context: context,
        apiKey: apiKey,
        mode: Mode.overlay, // Mode.fullscreen
        language: "en",
        components: [new Component(Component.country, "sa")]);

    locationController.text = pickupPrediction.description;
    notifyListeners();
  }
}
