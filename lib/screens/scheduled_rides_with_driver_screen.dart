import 'package:carpooling/screens/home.dart';
import 'package:carpooling/screens/ride_information_screen.dart';
import 'package:carpooling/state/app_states.dart';
import 'package:carpooling/utilities/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ScheduledRidesWithDriver extends StatelessWidget {
  const ScheduledRidesWithDriver({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    AuthService _authservice = AuthService();
    final Firestore _db = Firestore.instance;
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: ClipPath(
                clipper: AppBarClipper(),
                child: AppBar(
                  automaticallyImplyLeading: true,
                  backgroundColor: kappBarColor,
                  title: Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      'Scheduled Rides',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 30),
                    ),
                  ),
                ),
              )),
          preferredSize: Size(
            double.infinity,
            MediaQuery.of(context).size.height / 6,
          )),
      body: SingleChildScrollView(
        //controller: ,
        child: Container(
            child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: _db
                    .collection("scheduled_rides")
                    .where('open_seats' , isGreaterThan: 0)
                    //.where('driver', isEqualTo: 'N/A')
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text(
                          "It appears something is wrong with the network");
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                      return new ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot tripInfo =
                              snapshot.data.documents[index];
                          // String driverName =
                          //     getInfo(tripInfo["driver_id"], "firstname");
                          //print("trip info" + tripInfo.toString());
                          return GestureDetector(
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
                                height: 160,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // Text(driverName,
                                    //     style:
                                    //         kTimePickTextStyle), // we use it to get the driver info later but the method isnt here yet
                                    Text(
                                      "Driver: " + tripInfo["driver"],
                                      style: kTimePickTextStyle,
                                    ),
                                    Text(
                                        "Pick Up: " +
                                            tripInfo["pick_up_name"].toString(),
                                        style: kTimePickTextStyle),
                                    Text(
                                      "Destination: \n" +
                                          tripInfo["destination_name"]
                                              .toString(),
                                      style: kTimePickTextStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                        "Available Seats: " +
                                            (int.parse(tripInfo[
                                                        "maximum_seats"]) -
                                                    tripInfo["riders"].length)
                                                .toString(),
                                        style: kTimePickTextStyle),
                                    Text(
                                      "Date & Time of the Trip: \n\t\t\t\t\t\t" +
                                          // DateFormat.yMEd()
                                          //     .add_jms()
                                          //     .format(tripInfo["trip_time"]
                                          //         .toDate())
                                          //     .toString(), //for formatting
                                          tripInfo["trip_time"]
                                              .toString()
                                              .substring(
                                                  0,
                                                  tripInfo["trip_time"]
                                                      .toString()
                                                      .lastIndexOf(
                                                          ":")), //to remove the accuracy of time
                                      style: kTimePickTextStyle,
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                              ));
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

//  getInfo(DocumentReference d, String field) async {
//   final Firestore _db = Firestore.instance;
//   String toBeReturned;
//   String path = d.path;
//   print(d.path);
//   _db.document(path).get().then((doc) {
//     if (doc.exists) {
//       print("Document data:" + doc.data[field].toString());
//       toBeReturned = doc.data[field];
//       print("should return now");
//       return toBeReturned.toString();
//     } else {
//       //toBeReturned = "Document does not exist";
//       print("hasent returned1");
//     }
//     print("hasent returned2");
//     return toBeReturned.toString();
//   });
//   print("hasent returned3");
//   return toBeReturned;
// }
