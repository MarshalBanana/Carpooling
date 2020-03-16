import 'package:carpooling/screens/test_screen.dart';
import 'package:carpooling/state/app_states.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:carpooling/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
  const RideInfoScreen({
    Key key,
    @required this.appState,
  }) : super(key: key);
  final AppState appState;

  @override
  _RideInfoScreenState createState() => _RideInfoScreenState();
}

class _RideInfoScreenState extends State<RideInfoScreen> {
  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
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
                      title: Text("drivername"),
                      subtitle: Text("rating"))),
              Text(
                'Ride Details',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                  child: GoogleMap(
                    //polylines: appState.polylines,
                    initialCameraPosition: CameraPosition(
                        target: appState.initialPosition, zoom: 5),
                    onMapCreated: appState.onCreated,
                    myLocationEnabled: true,
                    //mapToolbarEnabled: true,
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
                  Text("Current number of Riders: 5",style: kmediumTitleTextStyle),
                  Text("Car: Lexus 512",style: kmediumTitleTextStyle),
                  Text("License Plate: Z U H 4 1 5 8",style: kmediumTitleTextStyle)
                ],
              ),
              Container(
                child: CustomButton(
                  buttonColor: kforwardButtonColor,
                  onPress: () {
                    setState(() {
                      appState.onCreatedRideInfo(LatLng(24.621687, 46.707276),
                          LatLng(24.736591, 46.702029));
                    });
                  },
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
