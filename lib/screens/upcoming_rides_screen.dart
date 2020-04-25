import 'package:carpooling/screens/home.dart';
import 'package:carpooling/screens/ride_information_screen.dart';
import 'package:carpooling/state/app_states.dart';
import 'package:carpooling/utilities/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpcomingRidesScreen extends StatelessWidget {
  const UpcomingRidesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Firestore _db = Firestore.instance;
    AppState appState = Provider.of<AppState>(context);
    AuthService _authservice = AuthService();
    AuthService _authService = new AuthService();
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: ClipPath(
                clipper: AppBarClipper(),
                child: AppBar(
                  automaticallyImplyLeading: true,
                  flexibleSpace: Image(image: AssetImage('assets/fullBackground.jpeg'),fit: BoxFit.cover,),
                  backgroundColor: kappBarColor,
                  title: Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      'Your Upcoming Rides',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 24),
                    ),
                  ),
                ),
              )),
          preferredSize: Size(
            double.infinity,
            MediaQuery.of(context).size.height / 6,
          )),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: _db
                    .collection("scheduled_rides")
                    //.where(, isGreaterThan:DateTime.now())  //DateTime.parse('triptime'.substring(0,'trip_time'.lastIndexOf(":")))
                    //.where('riders', arrayContains: _authService.fUser.uid)
                    .snapshots(),
                // .document("bbe2wmyy6LPhh373mb6U")
                // .collection("past_trips")
                // .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text(
                          "It appears something is wrong with the network");
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    print("AHAHHAHAHAHAH");
                    print(_authService.fUser.uid);
                    
                      return new ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot tripInfo =
                              snapshot.data.documents[index];
                              //print("trip time :" + tripInfo[trip_time])
                          // print("DateTime : " +
                          //     DateTime.parse(tripInfo['triptime']).toString());
                          // String driverName =
                          //     getInfo(tripInfo["driver_id"], "firstname");
                          print("trip info" + tripInfo.data['riders'].toString());
                          print("date of trip : " + tripInfo['trip_time']);
                          return Visibility(
                            visible: tripInfo['riders'].toString().contains(_authService.fUser.uid) &&
                             DateTime.parse(tripInfo['trip_time'])
                                 .isAfter(DateTime.now())  ,
                                  child: GestureDetector(
                                onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RideInfoScreen(
                                              appState: appState,
                                              destinationLocation: LatLng(
                                                  tripInfo['destination']
                                                      .latitude,
                                                  tripInfo['destination']
                                                      .longitude),
                                              pickUpLocation: LatLng(
                                                  tripInfo['pick_up'].latitude,
                                                  tripInfo['pick_up']
                                                      .longitude),
                                              driverName: tripInfo['driver'],
                                              rating: tripInfo['rating'],
                                              rideID: tripInfo.documentID,
                                              riders: tripInfo['riders'],
                                              carPlate: tripInfo['car_plate'],
                                              carType: tripInfo['car_type'],
                                              maximumSeats:
                                                  tripInfo['maximum_seats'],
                                              driverIsMale: tripInfo["is_male"],
                                              userID: _authservice.fUser.uid,
                                              tripTime: tripInfo['trip_time'],
                                            )));
                              },
                                child: Container(
                                  //padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  decoration: kpastRidesBox,
                                  margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  height: 200,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                            (tripInfo['driver'] == "N/A")
                                            ? "Driver is not yet set for this ride"
                                            : "Driver: " + tripInfo['driver'],
                                          style: kupcomingRidesTextStyle),
                                      Text(
                                          "Time of the Ride: " +
                                              tripInfo["trip_time"]
                                                  .substring(0,tripInfo['trip_time'].lastIndexOf(":")),
                                          style: kupcomingRidesTextStyle),
                                      Text(
                                          "Pick Up: " +
                                              tripInfo["pick_up_name"]
                                                  .toString(),
                                          style: kupcomingRidesTextStyle),
                                      Text(
                                          "Destination: \n" +
                                              tripInfo["destination_name"]
                                                  .toString(),
                                          style: kupcomingRidesTextStyle,
                                          textAlign: TextAlign.center,),
                                    ],
                                  ),
                                )),
                          );
                        },
                      );

                    case ConnectionState.done:
                      return Text("sd");
                  }
                  return Text("done");
                }),
          ],
        )),
      ),
    );
  }
}