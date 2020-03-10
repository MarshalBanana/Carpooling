import 'package:carpooling/screens/signin.dart';
import 'package:carpooling/screens/signup.dart';
import 'package:carpooling/screens/test_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carpooling/state/app_states.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'demo_register_screen.dart';
import 'home.dart';
import 'map_screen.dart';

class OrganizingScreen extends StatefulWidget {
  OrganizingScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _OrganizingScreenState createState() => _OrganizingScreenState();
}

class _OrganizingScreenState extends State<OrganizingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        extendBodyBehindAppBar: true,
//        appBar: AppBar(
//          iconTheme: IconThemeData(color: Colors.black),
//          elevation: 0.0,
//          backgroundColor: Colors.transparent,
//        ),
//        drawer: Drawer(
//          // Add a ListView to the drawer. This ensures the user can scroll
//          // through the options in the drawer if there isn't enough vertical
//          // space to fit everything.
//
//          child: ListView(
//            // Important: Remove any padding from the ListView.
//            padding: EdgeInsets.zero,
//            children: <Widget>[
//              Container(
//                  height: 80.0,
//                  child: DrawerHeader(
//                    child: Text('Ride With Us'),
//                    decoration: BoxDecoration(
//                      color: Colors.limeAccent[500],
//                    ),
//                  )),
//              ListTile(
//                leading: Icon(Icons.supervised_user_circle),
//                title: GestureDetector(
//                  onTap: () {},
//                  child: Container(
//                    child: Text("Customer Support"),
//                  ),
//                ),
//                onTap: () {},
//              ),
//              ListTile(
//                leading: Icon(Icons.account_circle),
//                title: GestureDetector(
//                  onTap: () {},
//                  child: Container(
//                    child: Text("Settings"),
//                  ),
//                ),
//                onTap: () {},
//              ),
//              ListTile(
//                leading: Icon(Icons.language),
//                title: Text('Change Language to Arabic'),
//                onTap: () {
//                  // Update the state of the app
//                  // ...
//                  // Then close the drawer
//                  Navigator.pop(context);
//                },
//              ),
//              ListTile(
//                leading: Icon(Icons.language),
//                title: Text('Change Language to English'),
//                onTap: () {
//                  // Update the state of the app
//                  // ...
//                  // Then close the drawer
//                  Navigator.pop(context);
//                },
//              ),
//            ],
//          ),
//        ),
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

  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    //If location is there we load maps if not we load a loading spinner and ask for them to enable location
//have to fix this at the bottom
    return SafeArea(
      //loadinscreen
      child: Scaffold(
        bottomNavigationBar: BottomNavyBar(
          iconSize: 30, itemCornerRadius: 50,
          selectedIndex: selectedPage,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            selectedPage = index;
            controller.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.directions_car),
                title: Text('Users'),
                activeColor: Colors.purpleAccent),
            BottomNavyBarItem(
                icon: Icon(Icons.notifications),
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
//        MapScreen(appState: appState),
        HomeScreen(),
        TestScreen(),
        SignUpScreen(), // <- this one adds a test user to the database on button click
        SignInScreen(),
//        DemoRegisterScreen(),
      ],
    );
  }
}
