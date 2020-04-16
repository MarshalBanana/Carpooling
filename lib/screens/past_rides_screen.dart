import 'package:carpooling/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:intl/intl.dart';

class PastRideScreen extends StatelessWidget {
  const PastRideScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      'Your Recent Rides',
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
        child: Container(
            child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: _db
                    .collection("users")
                    .document("bbe2wmyy6LPhh373mb6U")
                    .collection("past_trips")
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
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot tripInfo =
                              snapshot.data.documents[index];
                          // String driverName =
                          //     getInfo(tripInfo["driver_id"], "firstname");
                          //print("trip info" + tripInfo.toString());
                          return GestureDetector(
                              onTap: () {},
                              child: Container(
                                //padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                                decoration: kpastRidesBox,
                                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                                height: 160,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    // Text(driverName,
                                    //     style:
                                    //         kTimePickTextStyle), // we use it to get the driver info later but the method isnt here yet
                                    FutureBuilder(
                                        future: getInfo(tripInfo["driver_id"], "firstname"),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.none:
                                              return Text(
                                                  "It appears something is wrong with the network");
                                            case ConnectionState.waiting:
                                              return Text("waiting");
                                            case ConnectionState.active:
                                              return Text(
                                                "Driver Name: " + snapshot.data,
                                                style: kTimePickTextStyle,
                                              );
                                            case ConnectionState.done:
                                              print(snapshot.data);
                                              return Text(
                                                  "Driver Does not Exist");
                                          }
                                          return Text("data");
                                        }),
                                    Text(
                                        "Pick Up: " +
                                            tripInfo["pick_up_name"].toString(),
                                        style: kTimePickTextStyle),
                                    Text(
                                        "Destination: " +
                                            tripInfo["destination_name"]
                                                .toString(),
                                        style: kTimePickTextStyle),
                                    Text(
                                        "Paid: " +
                                            tripInfo["amount_paid"].toString() +
                                            " SAR",
                                        style: kTimePickTextStyle),
                                    Text(
                                      "Date & Time of the Trip: \n" +
                                          DateFormat.yMEd()
                                              .add_jms()
                                              .format(tripInfo["ride_end_time"]
                                                  .toDate())
                                              .toString(), //for formatting
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

 getInfo(DocumentReference d, String field) async {
  final Firestore _db = Firestore.instance;
  String toBeReturned;
  String path = d.path;
  print(d.path);
  _db.document(path).get().then((doc) {
    if (doc.exists) {
      print("Document data:" + doc.data[field].toString());
      toBeReturned = doc.data[field];
      print("should return now");
      return toBeReturned.toString();
    } else {
      //toBeReturned = "Document does not exist";
      print("hasent returned1");
    }
    print("hasent returned2");
    return toBeReturned.toString();
  });
  print("hasent returned3");
  return toBeReturned;
}
