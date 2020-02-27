import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carpooling/state/app_states.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'demo_register_screen.dart';
import 'map_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar :true,
        appBar: AppBar(
          iconTheme: IconThemeData(color:Colors.black),
          automaticallyImplyLeading: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.

          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                  height: 80.0,
                  child: DrawerHeader(
                    child: Text('Ride With Us'),
                    decoration: BoxDecoration(
                      color: Colors.limeAccent[500],
                    ),
                  )),
              ListTile(
                leading: Icon(Icons.supervised_user_circle),
                title: GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: Text("Customer Support"),
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: Text("Settings"),
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text('Change Language to Arabic'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text('Change Language to English'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Map());
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  final controller = PageController(
    initialPage: 0,
    keepPage: true,
  );
  changePage(int index) {
    setState(() {
      controller.animateToPage(
        selectedPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  int selectedPage = 1;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    //If location is there we load maps if not we load a loading spinner and ask for them to enable location
//have to fix this at the bottom
    return SafeArea(
 //loadinscreen
      child: Scaffold(
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: selectedPage,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            selectedPage = index;
            controller.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.apps),
              title: Text('Home'),
              activeColor: Colors.red,

      child: appState.initialPosition == null
          ? Container(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitFadingCube(
                      color: Colors.yellow,
                      size: 50.0,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: appState.locationServiceActive == false,
                  child: Text(
                    "Please enable location services!",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                )
              ],
            ))
          : Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: appState.initialPosition, zoom: 10),
                  onMapCreated: appState.onCreated,
                  myLocationEnabled: true,
                  //mapToolbarEnabled: true,
                  compassEnabled: true,
                  markers: appState.markers,
                  onCameraMove: appState.onCameraMove,
                  polylines: appState.polylines,
                ),
                Positioned(
                  top: 20.0,
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
                  top: 80.0,
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
                        await appState
                            .sendRequest(appState.prediction.description);
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
//master
            //till here
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.people),
                title: Text('Users'),
                activeColor: Colors.purpleAccent),
            BottomNavyBarItem(
                icon: Icon(Icons.message),
                title: Text('Messages'),
                activeColor: Colors.pink),
            BottomNavyBarItem(
                icon: Icon(Icons.settings),
                title: Text('Settings'),
                activeColor: Colors.blue),
          ],
        ),
        body: PageViewWidget(
          onChange: (index) {
            setState(() {
              selectedPage = index;
            });
          },
          controller: controller,
          appState: appState,
        ),
      ),
    );
  }
}

class PageViewWidget extends StatelessWidget {
  const PageViewWidget({
    Key key,
    @required this.controller,
    @required this.appState,
    @required this.onChange,
  }) : super(key: key);

  final PageController controller;
  final AppState appState;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      onPageChanged: (index) {
        onChange(index);
      },
      pageSnapping: true,
      children: <Widget>[
        MapScreen(appState: appState),
        DemoRegisterScreen(), // <- this one adds a test user to the database on button click
        DemoRegisterScreen(),
        DemoRegisterScreen(),
      ],
    );
  }
}
