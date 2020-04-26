import 'package:carpooling/screens/time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carpooling/state/app_states.dart';
import 'package:carpooling/utilities/date_time.dart';
import 'package:carpooling/utilities/auth_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key key,
    @required this.appState,
  }) : super(key: key);
  final AppState appState;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  FirebaseUser currentUser;
  AuthService _authService = AuthService();
  var showScheduler = false;
  bool isDriver = false;
  String switchTitle = "Rider";
  Icon switchIcon = Icon(Icons.people, color: Colors.green);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authService = AuthService();
  }

  void switchFunction(bool switchValue) {
    if (switchValue) {
      switchTitle = "Driver";
      switchIcon = Icon(
        Icons.traffic,
        color: Colors.indigo[900],
      );
    } else {
      switchTitle = "Rider";
      switchIcon = Icon(
        Icons.people,
        color: Colors.green,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Show Scheduler: " + showScheduler.toString());
    //final customPicker = new CustomPicker();
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(38.0),
      //         child: AppBar(
      //     automaticallyImplyLeading: true,
      //     backgroundColor: Colors.indigo[900],
      //   ),
      // ),
      body: Stack(
        children: <Widget>[
          new GoogleMap(
            initialCameraPosition: CameraPosition(
                target: widget.appState.initialPosition, zoom: 10),
            onMapCreated: widget.appState.onCreated,
            myLocationEnabled: true,
            mapToolbarEnabled: true,
            compassEnabled: true,
            markers: widget.appState.markers,
            onCameraMove: widget.appState.onCameraMove,
            polylines: widget.appState.polylines,
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.indigo[900],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Positioned(
            top: 70.0,
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
                controller: widget.appState.locationController,
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
                  hintText: "From",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                ),
                onTap: () async {
                  widget.appState.getOLocationAutoCompletePickup(context);
                  widget.appState.sendRequestPickup(
                      widget.appState.pickupPrediction.description);
                },
                onSubmitted: (value) {
                  setState(() {
                    widget.appState.sendRequestPickup(value);
                    showScheduler = true;
                    print("Show Scheduler: " + showScheduler.toString());
                  });
                },
              ),
            ),
          ),
          Positioned(
            top: 130.0,
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
                  // showScheduler = true;
                  widget.appState.getOLocationAutoCOmplete(context);
                  widget.appState
                      .sendRequest(widget.appState.prediction.description);
                },
                cursorColor: Colors.black,
                controller: widget.appState.destinationController,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  setState(() {
                    widget.appState.sendRequest(value);
                    showScheduler = true;
                    print("Show Scheduler: " + showScheduler.toString());
                  });
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
                  hintText: "To",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                ),
              ),
            ),
          ),
          Positioned(
            top: 180.0,
            right: 15.0,
            left: 120.0,
            child: Container(
              margin: EdgeInsets.only(left: 20, top: 10),
              height: 50,
              width: 50,
              //color: Colors.white,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 5.0),
                        blurRadius: 10,
                        spreadRadius: 3)
                  ]),
              child: SwitchListTile(
                //activeThumbImage: switchIcon,
                secondary: switchIcon,
                value: isDriver,
                title: Text(switchTitle),
                activeColor: Colors.indigo[900],
                inactiveTrackColor: Colors.green,
                onChanged: (bool newValue) {
                  setState(() {
                    print("isDriver: " + newValue.toString());
                    isDriver = newValue;
                    switchFunction(newValue);
                  });
                },
              ),
            ),
          ),
          Visibility(
              visible: showScheduler,
              child: TimeBookingManager(
                appState: widget.appState,
                isDriver: isDriver,
              ))
        ],
      ),
    );
  }
}

///most important method
void makeTrip() {}
