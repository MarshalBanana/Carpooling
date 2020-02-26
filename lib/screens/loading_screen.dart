import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../state/app_states.dart';
import 'home.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return SafeArea(
        child: appState.initialPosition == null
            ? Container(
                color: Colors.white,
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
                    ),
                  ],
                ))
            : MyHomePage(title: 'Flutter Demo Home Page'));
  }
}
