import 'package:carpooling/screens/test_screen.dart';
import 'package:carpooling/state/app_states.dart';
import 'package:carpooling/utilities/auth_service.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:carpooling/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:provider/provider.dart';
import 'package:carpooling/utilities/GPS_util.dart';
import 'package:carpooling/utilities/http_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

HttpHandler httpHandler = new HttpHandler();

// class Data {
//   LatLng destination;
//   LatLng initialPosition;
//   String riderName;
//   String gender;
//   int rating;
//   int availableSeats;
//   String car;
//   String licensePlate;

//   Data(
//       {this.destination,
//       this.initialPosition,
//       this.riderName,
//       this.gender,
//       this.rating,
//       this.availableSeats,
//       this.car,
//       this.licensePlate});
// }

class RideInfoScreen extends StatefulWidget {
  const RideInfoScreen(
      {Key key,
      @required this.appState,
      @required this.pickUpLocation,
      @required this.destinationLocation,
      this.driverName,
      this.rating,
      this.rideID,
      this.maximumSeats,
      this.riders,
      this.carPlate,
      this.carType,
      this.tripTime,
      this.driverIsMale,
      this.userID})
      : super(key: key);
  final AppState appState;
  final pickUpLocation;
  final destinationLocation;
  final driverName;
  final rating;
  final rideID;
  final maximumSeats;
  final riders;
  final carPlate;
  final carType;
  final driverIsMale;
  final tripTime;
  final userID;
  //AssetImage driverImage ;
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
  void joinRide() async {
    final Firestore _db = Firestore.instance;
    AuthService _authService = AuthService();
    var list = List<String>();
    String toAddToDatabase =
        this.widget.userID.toString() + ";" + "firstName" + "," + "lastName";
    list.add(toAddToDatabase);
    await _db
        .collection("scheduled_rides")
        .document(widget.rideID)
        .updateData({
          'riders': FieldValue.arrayUnion(list),
          'open_seats': int.parse(widget.maximumSeats) - widget.riders.length,
        })
        .then((doc) {
          print("Joined Ride succesfully!");
          Alert(
            context: context,
            title: "You have joined the ride succesfully",
            image: Image.asset("assets/bluetick.gif"),
          ).show();
        })
        .timeout(Duration(seconds: 2))
        .catchError((error) {
          print("Error joining ride");
          print(error);
          Alert(
            context: context,
            title: "Something went Wrong",
            image: Image.asset("assets/redx.png"),
          ).show();
        });
  }

  void assignDriver() async {
    final Firestore _db = Firestore.instance;
    AuthService _authService = AuthService();
    var list = List<String>();
    String toAddToDatabase =
        this.widget.userID.toString() + ";" + "firstName" + "," + "lastName";
    list.add(toAddToDatabase);
    //We get users info first
    String signedInUserID = _authService.fUser.uid;
    //then we get the user info from the user collection using the refernce of user ID
    Map<String, dynamic> userInfo =
          new Map<String, dynamic>();
      print("user info" + userInfo.toString());

      await _db
          .collection('users')
          .document(signedInUserID)
          .get()
          .then((value) {
        userInfo.addAll(value.data);
        print("value" + value.data.toString());
        print("user info" + userInfo.toString());
        return userInfo;
      });
    
    await _db
        .collection("scheduled_rides")
        .document(widget.rideID)
        .updateData({
          'driverid': userInfo['id'].toString(),
          'phone_number':
              userInfo['phone_number'].toString(),
          'age': userInfo["age"].toString(),
          'is_male': userInfo["is_male"].toString(),
          'rating': userInfo["rating"].toString(),
          'open_seats': int.parse(widget.maximumSeats) - widget.riders.length,
          'driver': userInfo['firstname'].toString() +
              " " +
              userInfo['lastname'].toString(),
          'maximum_seats': 4.toString(),
          'car_plate': "420 BLZ",
          'car_type': "Lexus A series",
        })
        .then((doc) {
          print("Assigned yourself as Rider!");
          Alert(
            context: context,
            title: "You are the driver of this ride",
            image: Image.asset("assets/bluetick.gif"),
          ).show();
        })
        .timeout(Duration(seconds: 2))
        .catchError((error) {
          print("Error becoming driver");
          print(error);
          Alert(
            context: context,
            title: "Something went Wrong",
            image: Image.asset("assets/redx.png"),
          ).show();
        });
  }

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
                'Driver Information',
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
                        backgroundImage: (widget.driverIsMale == "true")
                            ? AssetImage("assets/man.jpg")
                            : AssetImage("assets/woman.jpg"),
                      ),
                      title: Text(widget.driverName),
                      subtitle: Text((widget.driverName == "N/A")
                          ? '0'
                          : widget.rating.toString()))),
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
                        target: appState.initialPosition, zoom: 10),
                    onMapCreated: appState.onCreated,
                    myLocationEnabled: true,
                    mapToolbarEnabled: true,
                    compassEnabled: true,
                    markers: appState.markers,
                    onCameraMove: appState.onCameraMove,
                    polylines: appState.polylines,
                  ),
                  height: MediaQuery.of(context).size.height / 4),
              Visibility(
                visible: (widget.driverName != "N/A"),
                child: Wrap(
                  direction: Axis.vertical,
                  runAlignment: WrapAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                        "Number of Available Seats: " +
                            (int.parse(widget.maximumSeats) -
                                    widget.riders.length)
                                .toString(),
                        style: kmediumTitleTextStyle),
                    Text("Car: " + widget.carType,
                        style: kmediumTitleTextStyle),
                    Text("License Plate: " + widget.carPlate.toUpperCase(),
                        style: kmediumTitleTextStyle),
                    // Text(distance(LatLng(24.621687, 46.707276),
                    //         LatLng(24.736591, 46.702029), "K"))
                  ],
                ),
              ),
              Container(
                child: CustomButton(
                  buttonColor: kforwardButtonColor,
                  onPress: () {
                    if(widget.driverName == "N/A"){
                      setState(() {
                        assignDriver();
                      });
                    }
                    else{
                      setState(() {
                        joinRide();
                        widget.driverName;
                      });
                    }
                  },
                  text: Text(
                    (widget.driverName == "N/A")
                        ? 'Become Driver For This Ride'
                        : 'Join This Ride',
                        textAlign: TextAlign.center,
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
