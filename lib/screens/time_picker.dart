import 'package:carpooling/utilities/constants.dart';
import 'package:carpooling/utilities/utilities.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TimeBookingManager extends StatefulWidget {
  TimeBookingManager(
      {Key key,
      DateTime toBeDisplayed,
      bool repeatDaily,
      bool repeatWeekly,
      bool repeatMonthly,
      Function function})
      : super(key: key);

  DateTime toBeDisplayed = DateTime.now();
  bool repeatDaily = false;
  bool repeatWeekly = false;
  bool repeatMonthly = false;
  Function function;

  @override
  _TimeBookingManagerState createState() => _TimeBookingManagerState();
}

class _TimeBookingManagerState extends State<TimeBookingManager> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.4,
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
                  widget.toBeDisplayed.toString(),
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
                    onPress: widget.function,
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
