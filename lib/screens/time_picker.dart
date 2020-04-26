import 'package:carpooling/state/app_states.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:carpooling/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:carpooling/utilities/auth_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:carpooling/utilities/utilities.dart';
import 'home.dart';

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
  String _max_seats = null;
  bool repeatMonthly = false;
  final myController = TextEditingController();
  bool isDriver;
  AuthService _authService = AuthService();
  FirebaseUser currentUser;
  @override
  _TimeBookingManagerState createState() => _TimeBookingManagerState();
}

class _TimeBookingManagerState extends State<TimeBookingManager> {
  Color noButtonColor = kindigoThemeColor;
  Color dailyButtonColor = kindigoThemeColor;
  Color weeklyButtonColor = kindigoThemeColor;
  Color monthlyButtonColor = kindigoThemeColor;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.5,
      expand: true,
      builder: (BuildContext context, ScrollController scrollController) {
        int _num_of_seats;
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
                  color: kindigoThemeColor,
                  size: 40.0,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
//                    decoration: BoxDecoration(
//                        image: new DecorationImage(
//                            image: AssetImage('assets/fullBackground.jpeg'))),
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
                    buttonColor: kindigoThemeColor,
                    width: 5,
                    textColor: Colors.white),
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
                            setState(() {
                              monthlyButtonColor = kindigoThemeColor;
                              noButtonColor = Colors.deepOrange;
                              dailyButtonColor = kindigoThemeColor;
                              weeklyButtonColor = kindigoThemeColor;
                            });
                          },
                          text: Text("No"),
                          height: 3,
                          buttonColor: noButtonColor,
                          width: MediaQuery.of(context).size.width / 7,
                          textColor: Colors.white),
                      CustomButton(
                          onPress: () {
                            widget.repeatDaily = true;
                            widget.repeatWeekly = false;
                            widget.repeatMonthly = false;
                            setState(() {
                              monthlyButtonColor = kindigoThemeColor;
                              noButtonColor = kindigoThemeColor;
                              dailyButtonColor = Colors.deepOrange;
                              weeklyButtonColor = kindigoThemeColor;
                            });
                          },
                          text: Text("Daily"),
                          height: 3,
                          buttonColor: dailyButtonColor,
                          width: MediaQuery.of(context).size.width / 7,
                          textColor: Colors.white),
                      CustomButton(
                          onPress: () {
                            widget.repeatDaily = false;
                            widget.repeatWeekly = true;
                            widget.repeatMonthly = false;
                            setState(() {
                              monthlyButtonColor = kindigoThemeColor;
                              noButtonColor = kindigoThemeColor;
                              dailyButtonColor = kindigoThemeColor;
                              weeklyButtonColor = Colors.deepOrange;
                            });
                          },
                          text: Text("Weekly"),
                          height: 3,
                          buttonColor: weeklyButtonColor,
                          width: MediaQuery.of(context).size.width / 7,
                          textColor: Colors.white),
                      CustomButton(
                          onPress: () {
                            widget.repeatDaily = false;
                            widget.repeatWeekly = false;
                            widget.repeatMonthly = true;
                            setState(() {
                              monthlyButtonColor = Colors.deepOrange;
                              noButtonColor = kindigoThemeColor;
                              dailyButtonColor = kindigoThemeColor;
                              weeklyButtonColor = kindigoThemeColor;
                            });
                          },
                          text: Text("Monthly"),
                          height: 3,
                          buttonColor: monthlyButtonColor,
                          width: MediaQuery.of(context).size.width / 7,
                          textColor: Colors.white)
                    ],
                  ),
                ),
                Visibility(visible: widget.isDriver, child: Divider()),
                Visibility(
                  visible: widget.isDriver,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 5),
                    child: Container(
                      child: TextField(
                        controller: widget.myController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: false,
                          signed: true,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        maxLength: 1,
                        maxLengthEnforced: true,
                        onChanged: (String input) {
                          widget._max_seats = input;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          hintText: 'number of available seats',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
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
                      if (widget.isDriver &&
                          userInfo["car_plate"] == null &&
                          userInfo["car_type"] == null) {
                        Fluttertoast.showToast(
                            msg:
                                "You cannot be a driver without entering your car info at settings!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                      //.snapshots;//(includeMetadataChanges: false);
                      if (widget.isDriver) {
                        if (widget._max_seats == null) {
                          Fluttertoast.showToast(
                              msg: "Please fill in max seats",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);

                          return;
                        }
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
                              'maximum_seats': widget._max_seats,
                              'riders': [
                                userInfo['id'].toString() +
                                    ";" +
                                    userInfo['firstname'] +
                                    "," +
                                    userInfo['lastname']
                              ],
                              'car_plate': userInfo['car_plate'],
                              'car_type': userInfo['car_type'],
                              'repeat_daily': widget.repeatDaily,
                              'repeat_weekly': widget.repeatWeekly,
                              'repeat_monthly': widget.repeatMonthly,
                            })
                            .then((doc) {
                              print("doc save successful");
                              showDialog(
                                  context: context,
                                  builder: (context) => getDialog());
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
                              showDialog(
                                context: context,
                                builder: (context) => getDialog(),
                                barrierDismissible: false,
                              );
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
                    buttonColor: kindigoThemeColor,
                    width: 20,
                    textColor: Colors.white)
              ],
            ),
          ),
        );
      },
    );
  }

  getDialog() {
    return AlertDialog(
      title: Text('Awesome!\n You can now wait for others to join'),
      elevation: 24.0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: <Widget>[
        Row(
          children: <Widget>[
            CustomButton(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 16,
              buttonColor: kindigoThemeColor,
              onPress: () {
                Navigator.pop(context, 1);
                Navigator.pop(context, 1);
              },
              text: Text('OK!'),
              textColor: Colors.white,
            ),
          ],
        )
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {@required this.onPress,
      @required this.text,
      @required this.height,
      @required this.buttonColor,
      @required this.width,
      @required this.textColor});

  final Function onPress;
  final Color buttonColor;
  final double width;
  final double height;
  final Text text;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: buttonColor,
        child: MaterialButton(
          onPressed: onPress,
          minWidth: width,
          height: height,
          child: text,
          textColor: textColor,
        ),
      ),
    );
  }
}
