import 'package:carpooling/screens/test_screen.dart';
import 'package:carpooling/state/app_states.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:carpooling/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:provider/provider.dart';
import 'package:carpooling/utilities/GPS_util.dart';
import 'package:carpooling/utilities/http_handler.dart';

HttpHandler httpHandler = new HttpHandler();

class Data {
  LatLng destination;
  LatLng initialPosition;
  String riderName;
  String gender;
  int rating;
  int availableSeats;
  String car;
  String licensePlate;

  Data(
      {this.destination,
      this.initialPosition,
      this.riderName,
      this.gender,
      this.rating,
      this.availableSeats,
      this.car,
      this.licensePlate});
}

class RideInfoScreen extends StatefulWidget {
  const RideInfoScreen(
      {Key key,
      @required this.appState,
      @required this.pickUpLocation,
      @required this.destinationLocation,
      @required this.driverName,
      this.rating})
      : super(key: key);
  final AppState appState;
  final pickUpLocation;
  final destinationLocation;
  final driverName;
  final rating;

  @override
  _RideInfoScreenState createState() => _RideInfoScreenState();
}

class _RideInfoScreenState extends State<RideInfoScreen> {
  // @override
  // void initState() {
  //   AppState appState = Provider.of<AppState>(context);
  //   super.initState();
  //   appState.onCreatedRideInfo(widget.pickUpLocation,
  //                         widget.destinationLocation);
  // }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appState.onCreatedRideInfo(
            widget.pickUpLocation, widget.destinationLocation);
      });
    } catch (e) {
      print("error: " + e.toString());
    }
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
                      'Ride Information',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 25),
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
              Text(
                'Recent Rides',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                  decoration: BoxDecoration(
                    color: kboxColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  padding: EdgeInsets.all(2.0),
                  child: ListTile(
                      leading: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/man.jpg"),
                      ),
                      title: Text(widget.driverName),
                      subtitle: Text(widget.rating))),
              Text(
                'Ride Details',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                  child: new GoogleMap(
                    //polylines: appState.polylines,
                    initialCameraPosition: CameraPosition(
                        target: appState.initialPosition, zoom: 5),
                    onMapCreated: appState.onCreated,
                    myLocationEnabled: true,
                    mapToolbarEnabled: true,
                    compassEnabled: true,
                    markers: appState.markers,
                    onCameraMove: appState.onCameraMove,
                    polylines: appState.polylines,
                  ),
                  height: MediaQuery.of(context).size.height / 4),
              Wrap(
                direction: Axis.vertical,
                runAlignment: WrapAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Current number of Riders: 5",
                      style: kmediumTitleTextStyle),
                  Text("Car: Lexus 512", style: kmediumTitleTextStyle),
                  Text("License Plate: Z U H 4 1 5 8",
                      style: kmediumTitleTextStyle),
                  FutureBuilder(
                    future: httpHandler.distanceRequest(
                        widget.pickUpLocation, widget.destinationLocation),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      // if(snapshot.connectionState== ConnectionState.done){
                      //   print(snapshot.data);
                      //   return Text("snapshot.data");
                      // }
                      // else {
                      //   return Text("Something is wrong with the connection");
                      // }
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text(
                              "It appears something is wrong with the network");
                        case ConnectionState.waiting:
                          return Text("waiting");
                        case ConnectionState.active:
                          return Text("active");
                        case ConnectionState.done:
                          print(snapshot.data);
                          return Text("snapshot.data");
                      }
                    },
                  ),

                  // Text(distance(LatLng(24.621687, 46.707276),
                  //         LatLng(24.736591, 46.702029), "K"))
                ],
              ),
              Container(
                child: CustomButton(
                  buttonColor: kforwardButtonColor,
                  onPress: () {},
                  text: Text(
                    'Join This Ride',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  height: MediaQuery.of(context).size.height / 6,
                  textColor: Colors.black,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
