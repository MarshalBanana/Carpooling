import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carpooling/state/app_states.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Map());
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    //If location is there we load maps if not we load a loading spinner and ask for them to enable location
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BubbledNavigationBar(
          defaultBubbleColor: Colors.blue,
          onTap: (index) {
            // handle tap
          },
          items: <BubbledNavigationBarItem>[
            BubbledNavigationBarItem(
              icon: Icon(CupertinoIcons.home, size: 30, color: Colors.red),
              activeIcon:
                  Icon(CupertinoIcons.home, size: 30, color: Colors.white),
              title: Text(
                'Home',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            BubbledNavigationBarItem(
              icon: Icon(CupertinoIcons.phone, size: 30, color: Colors.purple),
              activeIcon:
                  Icon(CupertinoIcons.phone, size: 30, color: Colors.white),
              title: Text(
                'Phone',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            BubbledNavigationBarItem(
              icon: Icon(CupertinoIcons.info, size: 30, color: Colors.teal),
              activeIcon:
                  Icon(CupertinoIcons.info, size: 30, color: Colors.white),
              title: Text(
                'Info',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            BubbledNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled,
                  size: 30, color: Colors.cyan),
              activeIcon: Icon(CupertinoIcons.profile_circled,
                  size: 30, color: Colors.white),
              title: Text(
                'Profile',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        body: Stack(
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
        ),
      ),
    );
  }
}
