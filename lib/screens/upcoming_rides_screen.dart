import 'package:carpooling/screens/home.dart';
import 'package:carpooling/utilities/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:intl/intl.dart';

class UpcomingRidesScreen extends StatelessWidget {
  const UpcomingRidesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Firestore _db = Firestore.instance;

    AuthService _authService = new AuthService();
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: ClipPath(
                clipper: AppBarClipper(),
                child: AppBar(
                  automaticallyImplyLeading: false,
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
                                onTap: () {},
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
                                          "Destination: " +
                                              tripInfo["destination_name"]
                                                  .toString(),
                                          style: kupcomingRidesTextStyle),
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