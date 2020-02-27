import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carpooling/state/app_states.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({
    Key key,
    @required this.appState,
  }) : super(key: key);

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: appState.initialPosition, zoom: 10),
          onMapCreated: appState.onCreated,
          myLocationEnabled: true,
          //mapToolbarEnabled: true,
          compassEnabled: true,
          markers: appState.markers,
          onCameraMove: appState.onCameraMove,
          polylines: appState.polylines,
        ),
        Positioned(
          top: 50.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 5.0),
                    blurRadius: 10,
                    spreadRadius: 3)
              ],
            ),
            child: TextField(
              cursorColor: Colors.black,
              controller: appState.locationController,
              decoration: InputDecoration(
                icon: Container(
                  margin: EdgeInsets.only(left: 20, top: 5),
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                ),
                hintText: "pick up",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
              ),
            ),
          ),
        ),
        Positioned(
          top: 105.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 5.0),
                    blurRadius: 10,
                    spreadRadius: 3)
              ],
            ),
            child: TextField(
              onTap: () async {
                // Prediction prediction = await PlacesAutocomplete.show(
                //     context: context,
                //     apiKey: "AIzaSyAS6yFOpTAblkIYrYIxKsFpRP9caH58MYc",
                //     mode: Mode.fullscreen,
                //     language: "en",
                //     components: [Component(Component.locality, "eg")]);
                //     appState.displayPrediction(prediction);
                //     appState.destinationController.text = prediction.description;
                await appState.getOLocationAutoCOmplete(context);
                await appState.sendRequest(appState.prediction.description);
              },
              cursorColor: Colors.black,
              controller: appState.destinationController,
              textInputAction: TextInputAction.go,
              onSubmitted: (value) {
                appState.sendRequest(value);
              },
              decoration: InputDecoration(
                icon: Container(
                  margin: EdgeInsets.only(left: 20, top: 5),
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.local_taxi,
                    color: Colors.black,
                  ),
                ),
                hintText: "destination",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
