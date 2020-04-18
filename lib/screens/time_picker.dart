import 'package:carpooling/state/app_states.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:carpooling/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:carpooling/utilities/auth_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TimeBookingManager extends StatefulWidget {
  TimeBookingManager({
    Key key,
    DateTime toBeDisplayed,
    @required this.appState,
    @required this.isDriver,
    // bool repeatDaily,
    // bool repeatWeekly,
    // bool repeatMonthly,
  }) : super(key: key);
  final AppState appState;
  DateTime toBeDisplayed = DateTime.now();
  //String timeInFormat = DateTime.now().toString(); //this is for showing the time in correct format
  bool repeatDaily = false;
  bool repeatWeekly = false;
  bool repeatMonthly = false;
  bool isDriver;
  AuthService _authService = AuthService();
  FirebaseUser currentUser;
  @override
  _TimeBookingManagerState createState() => _TimeBookingManagerState();
}

class _TimeBookingManagerState extends State<TimeBookingManager> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.5,
      expand: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          controller: scrollController,
          child: Container(
            width: 50,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.keyboard_arrow_up,
                  color: kappBarColor,
                  size: 40.0,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: Text("Start Your Ride",
                        style: kmediumTitleTextStyle,
                        textAlign: TextAlign.center),
                  ),
                ),
                Divider(),
                CustomButton(
                    onPress: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime(2024, 12, 30, 23, 59),
                          onChanged: (date) {
                        print('change $date in time zone ' +
                            date.timeZoneOffset.inHours.toString());
                        // customPicker.
                      }, onConfirm: (date) {
                        setState(() {
                          widget.toBeDisplayed = date;
                          print("tobeDisplayed: " +
                              widget.toBeDisplayed.toString());
                          print('confirm $date');
                        });
                      }, locale: LocaleType.en);
                    },
                    text: Text("Change Ride Time"),
                    height: 3,
                    buttonColor: kforwardButtonColor,
                    width: 5,
                    textColor: Colors.black),
                Text(
                  DateFormat.yMEd()
                      .add_jms()
                      .format(widget.toBeDisplayed)
                      .toString(),
                  style: kTimePickTextStyle,
                  textAlign: TextAlign.center,
                ),
                Divider(),
                Text("Would You Like to Repeat This Ride",
                    style: kmediumTitleTextStyle, textAlign: TextAlign.center),
                SafeArea(
                  child: Row(
                    children: <Widget>[
                      CustomButton(
                          onPress: () {
                            widget.repeatDaily = false;
                            widget.repeatWeekly = false;
                            widget.repeatMonthly = false;
                          },
                          text: Text("No"),
                          height: 3,
                          buttonColor: kforwardButtonColor,
                          width: 5,
                          textColor: Colors.black),
                      CustomButton(
                          onPress: () {
                            widget.repeatDaily = true;
                            widget.repeatWeekly = false;
                            widget.repeatMonthly = false;
                          },
                          text: Text("Daily"),
                          height: 3,
                          buttonColor: kforwardButtonColor,
                          width: 5,
                          textColor: Colors.black),
                      CustomButton(
                          onPress: () {
                            widget.repeatDaily = false;
                            widget.repeatWeekly = true;
                            widget.repeatMonthly = false;
                          },
                          text: Text("Weekly"),
                          height: 3,
                          buttonColor: kforwardButtonColor,
                          width: 5,
                          textColor: Colors.black),
                      CustomButton(
                          onPress: () {
                            widget.repeatDaily = false;
                            widget.repeatWeekly = false;
                            widget.repeatMonthly = true;
                          },
                          text: Text("Monthly"),
                          height: 3,
                          buttonColor: kforwardButtonColor,
                          width: 5,
                          textColor: Colors.black)
                    ],
                  ),
                ),
                Divider(),
                CustomButton(
                    onPress: () async {
                      //we create ride here since its easier  and we can get all the information here without a lot of hassle.
                      // this.widget.currentUser = await widget._authService.getCurrentUser();
                      // widget._authService.getUserData();
                      // print('-????????-');
                      // print("initial: " +
                      //     widget.appState.initialPosition.toString());
                      // print("last: " + widget.appState.lastPosition.toString());
                      // print("last name : " +
                      //     widget.appState.destinationController.value.text);
                      // //await widget._authService.getUserData();
                      final Firestore _db = Firestore.instance;
                      AuthService _authService = AuthService();

                      String id = _authService.fUser.uid;
                      print(id);
                      Map<String, dynamic> userInfo =
                          new Map<String, dynamic>();
                      print("user info" + userInfo.toString());

                      await _db
                          .collection('users')
                          .document(id)
                          .get()
                          .then((value) {
                        userInfo.addAll(value.data);
                        print("value" + value.data.toString());
                        print("user info" + userInfo.toString());
                        return userInfo;
                      });
                      //.snapshots;//(includeMetadataChanges: false);
                      if (widget.isDriver) {
                        _db
                            .collection("scheduled_rides")
                            .add({
                              'id': userInfo['id'].toString(),
                              'firstname': userInfo['firstname'].toString(),
                              'lastname': userInfo['lastname'].toString(),
                              'phone_number':
                                  userInfo['phone_number'].toString(),
                              'age': userInfo["age"].toString(),
                              'is_male': userInfo["is_male"].toString(),
                              'rating': userInfo["rating"].toString(),
                              'pick_up': GeoPoint(
                                  widget.appState.initialPosition.latitude,
                                  widget.appState.initialPosition.longitude),
                              'pick_up_name':
                                  widget.appState.locationController.text,
                              'destination': GeoPoint(
                                  widget.appState.lastPosition.latitude,
                                  widget.appState.lastPosition.longitude),
                              'destination_name':
                                  widget.appState.destinationController.text,
                              'trip_time': widget.toBeDisplayed.toString(),
                              'driver': userInfo['firstname'].toString() +
                                  " " +
                                  userInfo['lastname'].toString(),
                              'maximum_seats': 4.toString(),
                              'riders': [
                                userInfo['id'].toString() +
                                    ";" +
                                    userInfo['firstname'] +
                                    "," +
                                    userInfo['lastname']
                              ],
                              'car_plate': "1234 ABCD",
                              'car_type': "Lexus",
                              'repeat_daily': widget.repeatDaily,
                              'repeat_weekly': widget.repeatWeekly,
                              'repeat_monthly': widget.repeatMonthly,
                            })
                            .then((doc) {
                              print("doc save successful");
                              Alert(
                                context: context,
                                title: "Your Ride has been succesfully created",
                                image: Image.asset("assets/bluetick.gif"),
                              ).show();
                            })
                            .timeout(Duration(seconds: 2))
                            .catchError((error) {
                              print("doc save error");
                              print(error);
                              Alert(
                                context: context,
                                title: "Something went Wrong",
                                image: Image.asset("assets/redx.png"),
                              ).show();
                            });
                      } else {
                        _db
                            .collection("scheduled_rides")
                            .add({
                              'id': userInfo['id'].toString(),
                              'firstname': userInfo['firstname'].toString(),
                              'lastname': userInfo['lastname'].toString(),
                              'phone_number':
                                  userInfo['phone_number'].toString(),
                              'age': userInfo["age"].toString(),
                              'is_male': userInfo["is_male"].toString(),
                              'rating': userInfo["rating"].toString(),
                              'driver': "N/A",
                              'pick_up': GeoPoint(
                                  widget.appState.initialPosition.latitude,
                                  widget.appState.initialPosition.longitude),
                              'pick_up_name':
                                  widget.appState.locationController.text,
                              'destination': GeoPoint(
                                  widget.appState.lastPosition.latitude,
                                  widget.appState.lastPosition.longitude),
                              'destination_name':
                                  widget.appState.destinationController.text,
                              'trip_time': widget.toBeDisplayed.toString(),
                              'maximum_seats': 0.toString(),
                              'riders': [
                                userInfo['id'].toString() +
                                    ";" +
                                    userInfo['firstname'] +
                                    "," +
                                    userInfo['lastname']
                              ],
                              'car_plate': "",
                              'car_type': "",
                              'repeat_daily': widget.repeatDaily,
                              'repeat_weekly': widget.repeatWeekly,
                              'repeat_monthly': widget.repeatMonthly,
                            })
                            .then((doc) {
                              print("doc save successful");
                              Alert(
                                context: context,
                                title: "Your Ride has been succesfully created",
                                image: Image.asset("assets/bluetick.gif"),
                              ).show();
                            })
                            .timeout(Duration(seconds: 2))
                            .catchError((error) {
                              print("doc save error");
                              print(error);
                              Alert(
                                context: context,
                                title: "Something went Wrong",
                                image: Image.asset("assets/redx.png"),
                              ).show();
                            });
                      }
                    },
                    text: Text("Book Your Ride"),
                    height: 15,
                    buttonColor: kforwardButtonColor,
                    width: 20,
                    textColor: Colors.black)
              ],
            ),
          ),
        );
      },
    );
  }
}

void createRide() async {}
