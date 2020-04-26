import 'package:carpooling/screens/map_screen.dart';
import 'package:carpooling/screens/ride_information_screen.dart';
import 'package:carpooling/state/app_states.dart';
import 'package:carpooling/utilities/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:carpooling/utilities/utilities.dart';

import '../utilities/GPS_util.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Firestore _db = Firestore.instance;
  double allowedDistance = 12;

  @override
  void initState() {
    super.initState();
    auth = AuthService();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: ClipPath(
                clipper: AppBarClipper(),
                child: AppBar(
                  flexibleSpace: Image(
                    image: AssetImage('assets/fullBackground.jpeg'),
                    fit: BoxFit.cover,
                  ),
                  backgroundColor: kappBarColor,
                  automaticallyImplyLeading: false,
                  title: Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      'Home',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 24),
                    ),
                  ),
                ),
              )
//              painter: AppBarPainter(),
//              size: Size(double.infinity, 100),

              ),
          preferredSize: Size(
            double.infinity,
            MediaQuery.of(context).size.height / 6,
          )),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text(
              //   'Recent Rides',
              //   style: TextStyle(
              //       fontFamily: 'Montserrat',
              //       fontSize: 20,
              //       fontWeight: FontWeight.w600),
              // ),
              // StreamBuilder(
              //     stream: _db.collection("user_auth").snapshots(),
              //     builder: (context, snapshot) {
              //       switch (snapshot.connectionState) {
              //         case ConnectionState.none:
              //           return Text(
              //               "It appears something is wrong with the network");
              //         case ConnectionState.waiting:
              //           return Center(child: CircularProgressIndicator());
              //         case ConnectionState.active:
              //           return Expanded(
              //             child: new ListView.builder(
              //                 shrinkWrap: true,
              //                 scrollDirection: Axis.horizontal,
              //                 itemCount: snapshot.data.documents.length,
              //                 itemBuilder: (context, index) {
              //                   DocumentSnapshot riderInfo =
              //                       snapshot.data.documents[index];
              //                   return Material(
              //                       child: GestureDetector(
              //                     onTap: () {
              //                       // Navigator.push(
              //                       //   context,
              //                       //   MaterialPageRoute(
              //                       //       builder: (context) => RideInfoScreen(
              //                       //             appState: appState,
              //                       //           )),
              //                       // );
              //                     },
              //                     child: Container(
              //                       decoration: BoxDecoration(
              //                           shape: BoxShape.rectangle,
              //                           borderRadius: BorderRadius.all(
              //                               Radius.circular(8.0)),
              //                           color: kboxColor),
              //                       margin: EdgeInsets.all(4),
              //                       height: 16,
              //                       child: Column(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceEvenly,
              //                         children: <Widget>[
              //                           Text(riderInfo["email"]),
              //                           Text(riderInfo["mobile"])
              //                           //Text(ds["user_id"].toString())
              //                         ],
              //                       ),
              //                     ),
              //                   ));
              //                 }),
              //           );
              //         case ConnectionState.done:
              //           return Text("sd");
              //       }
              //       return Text("stream Complete");
              //     }),
              Text(
                'Rides near You',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              StreamBuilder(
                  stream: _db.collection("scheduled_rides").snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text(
                            "It appears something is wrong with the network");
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                        return Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: new ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
//                            itemExtent: MediaQuery.of(context).size.width / 2,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              if (snapshot.hasData) {
                                print("trying to get trip info");
                                DocumentSnapshot tripInfo =
                                    snapshot.data.documents[index];
                                // print("length" +
                                //     snapshot.data.documents.length.toString());
                                // if (tripInfo["driver"] == "Osama") {
                                //   print(true);
                                // }
                                // print(tripInfo.data);
                                // print(tripInfo.documentID);
                                // print(tripInfo["driver"]);

                                GeoPoint pickUpGeo = tripInfo["pick_up"];
                                GeoPoint destinationGeo =
                                    tripInfo["destination"];
                                LatLng pickup = new LatLng(
                                    pickUpGeo.latitude, pickUpGeo.longitude);
                                LatLng destination = new LatLng(
                                    destinationGeo.latitude,
                                    destinationGeo.longitude);

                                // print("A" * 100);
                                // if(distance(, point2))
                                var current = appState.initialPosition;
                                // print(current.toString());
                                // if(distance(current, tripInfo[] || )){
                                print(distance(current, pickup));
                                print("entered");
                                return Visibility(
                                  visible: tripInfo['driver']
                                              .toString()
                                              .compareTo("N/A") !=
                                          0 &&
                                      (double.parse(distance(current, pickup)) <
                                              100 ||
                                          double.parse(distance(
                                                  current, destination)) <
                                              100),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Material(
                                      child: GestureDetector(
                                        onTap: () {
                                          AuthService _authservice =
                                              AuthService();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RideInfoScreen(
                                                      appState: appState,
                                                      destinationLocation: LatLng(
                                                          tripInfo[
                                                                  'destination']
                                                              .latitude,
                                                          tripInfo[
                                                                  'destination']
                                                              .longitude),
                                                      pickUpLocation: LatLng(
                                                          tripInfo['pick_up']
                                                              .latitude,
                                                          tripInfo['pick_up']
                                                              .longitude),
                                                      driverName:
                                                          tripInfo['driver'],
                                                      rating:
                                                          tripInfo['rating'],
                                                      rideID:
                                                          tripInfo.documentID,
                                                      riders:
                                                          tripInfo['riders'],
                                                      carPlate:
                                                          tripInfo['car_plate'],
                                                      carType:
                                                          tripInfo['car_type'],
                                                      maximumSeats: tripInfo[
                                                          'maximum_seats'],
                                                      driverIsMale:
                                                          tripInfo["is_male"],
                                                      userID: _authservice
                                                          .fUser.uid,
                                                      tripTime:
                                                          tripInfo['trip_time'],
                                                    )),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/fullBackground.jpeg"),
                                                  fit: BoxFit.fill),
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              color: kboxColor),
                                          margin: EdgeInsets.all(4),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Text(
                                                  "Driver: " +
                                                      tripInfo["driver"],
                                                  style:
                                                      kupcomingRidesTextStyle,
                                                ),
                                                Text(
                                                    "From: " +
                                                        tripInfo[
                                                            "pick_up_name"],
                                                    style:
                                                        kupcomingRidesTextStyle),
                                                Text(
                                                  "To: \n" +
                                                      tripInfo[
                                                          "destination_name"],
                                                  style:
                                                      kupcomingRidesTextStyle,
                                                  textAlign: TextAlign.center,
                                                ),
                                                // getUserInfo(riderInfo["user_id"]
                                                //     .toString()
                                                //     .substring(7))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  child: Text("There is no data"),
                                );
                              }
                            },
                          ),
                        );
                      case ConnectionState.done:
                        return Text("sd");
                    }
                    return Container();
                  }),
//              Container(
//                child: CustomButton(
//                  onPress: () {
//                    print('logout button pressed');
//                    logout();
//                  },
//                  text: Text('temp logout button'),
//                  buttonColor: kforwardButtonColor,
//                  height: MediaQuery.of(context).size.height / 12,
//                  textColor: Colors.white,
//                  width: double.infinity,
//                ),
//              ),
              Container(
                child: CustomButton(
                  buttonColor: kindigoThemeColor,
                  onPress: () {
                    appState.clearMarkers();

                    try {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MapScreen(appState: appState)),
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  text: Text(
                    'Schedule a Ride',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  height: MediaQuery.of(context).size.height / 6,
                  textColor: Colors.white,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AuthService auth;
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();
    p.lineTo(size.width, 0);
    p.lineTo(size.width, size.height / 1.5);
//    p.cubicTo(0, 42, 20, 40, double.infinity, 42);
    p.cubicTo(
      size.width / 1.6,
      3 * size.height / 2.1,
      3 * size.width / 8,
      size.height / 1.6,
      0,
      size.height / 1.5,
    );
    p.lineTo(0, 0);
//    p.lineTo(0, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

//age can_drive first name last name is_male rating
getUserInfo(String userID) {
  // final Firestore _db = Firestore.instance;
  // //Stream document = _db .collection("user").snapshots();
  // Stream<DocumentSnapshot>  userInfo = _db.collection("users").document(userID).snapshots().;
  // //var document =  Firestore.instance.collection('users').document(userID).snapshots();

  // print("*"*80);
  // print(userInfo['age']);
  // print(document["firstname"]);
  // print(document["rating"]);
  // print("*"*80);
  // //return {'age': document["age"],'can_drive' : document["can_drive"]};
  // return "dsadasa";
  StreamBuilder(
      stream: Firestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(
            'No Data...',
          );
        } else {
          DocumentSnapshot items = snapshot.data.document(userID);
          print("B" * 100);
          print(items["age"]);
          return Text(items["age"]);
        }
      });
}
