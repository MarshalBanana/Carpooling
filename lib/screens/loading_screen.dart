
import 'package:carpooling/utilities/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../state/app_states.dart';
import 'organizing_screen.dart';
import '../screens/signup.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  AuthService auth;

  @override
  void initState() {
    super.initState();
    auth = AuthService();
  }

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
                          color: Colors.indigo,
                          size: 50.0,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ))
            : isSignedIn());
  }

  isSignedIn() {
    if (auth.fUser != null) {
      return OrganizingScreen(title: 'Carpooling');
    } else
      return SignUpScreen();
  }
}
