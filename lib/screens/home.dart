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
    return Scaffold(body: Map());
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

    return SafeArea(
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
