import 'package:carpooling/screens/signin.dart';
import 'package:carpooling/utilities/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../state/app_states.dart';
import 'organizing_screen.dart';
import '../screens/signup.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  AuthService auth;
  SharedPreferences prefs;
  dynamic appState;
  @override
  void initState() {
    super.initState();
    auth = AuthService();
    getPrefs();
  }

  ///old build method
//  @override
//  Widget build(BuildContext context) {
//    appState = Provider.of<AppState>(context);
//
//    return SafeArea(
//        child: appState.initialPosition == null
//            ? Container(
//                color: Colors.white,
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        SpinKitFadingCube(
//                          color: Colors.indigo,
//                          size: 50.0,
//                        )
//                      ],
//                    ),
//                    SizedBox(
//                      height: 20,
//                    ),
//                  ],
//                ))
//            : isSignedIn());
//  }
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);

    return getFutureBuilder();
  }

  getFutureBuilder() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (appState.initialPosition != null) {
            if (auth.fUser != null) {
              print('first case of SigningIn');
              return OrganizingScreen(title: 'Carpooling');
            } else {
              if (prefs != null) {
                if (!auth.isBusy && !isSigningIn) {
                  if (auth.fUser != null) {
                    print('first case of SigningIn');
                    return OrganizingScreen(title: 'Carpooling');
                  } else {
                    return SignUpScreen();
                  }
                } else
                  print('waiting for signing in');
                return Center(
                  child: SpinKitFadingCube(color: Colors.indigo, size: 50.0),
                );
              } else {
                print('waiting for prefs');
                return Center(
                  child: SpinKitFadingCube(color: Colors.indigo, size: 50.0),
                );
              }
            }
          } else {
            print('waiting for initial position');
            return Center(
              child: SpinKitFadingCube(color: Colors.indigo, size: 50.0),
            );
          }
        } else
          print(snapshot.data.toString());
        return Center(
          child: SpinKitFadingCube(color: Colors.indigo, size: 50.0),
        );
      },
      future: isSignedIn(),
    );
  }

  bool isSigningIn = false;
  isSignedIn() async {
    print('isSignedIn(): checking initialposition');
    if (appState.initialPosition != null) {
      print('isSignedIn(): checking if user already signed in');
      if (auth.fUser != null) {
        return true;
      } else {
        print('isSignedIn(): trying to get credentials from prefs');
        isSigningIn = true;
        String password = prefs.getString('password');
        String email = prefs.getString('email');
        print('haha');
//        print('isSignedIn(): email: ' + email);
//        print('isSignedIn(): password: ' + password);
        try {
          print('isSignedIn(): checking received prefs if null');
          if (email != null && password != null) {
            await auth.emailSignIn(email, password);
            print('isSignedIn(): checking checking if signed in user is null');
            if (auth.fUser == null) {
              print('isSignedIn(): no user');
              isSigningIn = false;
              return true;
            }
            print('isSignedIn(): no user');
            isSigningIn = false;
            return true;
          } else {
            isSigningIn = false;
            print('they were length 0');
            return true;
          }
        } catch (e) {
          print('in catch they were length 0');
          print(e);
          isSigningIn = false;
          return true;
        }
      }
    }
  }

  void getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
}
