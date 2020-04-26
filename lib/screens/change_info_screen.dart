import 'package:carpooling/screens/home.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utilities/utilities.dart';

class ChangeInfoScreen extends StatefulWidget {
  ChangeInfoScreen(
      {Key key,
      @required this.titleText,
      @required this.descriptionText,
      @required this.userID,
      @required this.hintText,
      @required this.fieldToChange})
      : super(key: key);
  final titleText;
  final descriptionText;
  final userID;
  final hintText;
  final myController = TextEditingController();
  final fieldToChange;
  @override
  _ChangeInfoScreenState createState() => _ChangeInfoScreenState();
}

class _ChangeInfoScreenState extends State<ChangeInfoScreen> {
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    this.widget.myController.dispose();
    super.dispose();
  }

  changeName() {
    int x = this.widget.myController.text.indexOf(" ");
    setState(() {
      _db.collection("users").document(this.widget.userID).updateData({
        "firstname": this.widget.myController.text.substring(0, x),
        "lastname": this.widget.myController.text.substring(x)
      });
    });
  }

  changeOtherFields() {
    setState(() {
      _db.collection("users").document(this.widget.userID).updateData(
          {this.widget.fieldToChange: this.widget.myController.text});
    });
  }

  final Firestore _db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.indigo[900],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 40),
              Text(
                this.widget.titleText,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 22),
              Text(
                this.widget.descriptionText,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              TextField(
                maxLengthEnforced: true,
                maxLength:
                    (this.widget.fieldToChange == "phone_number") ? 10 : 100,
                controller: this.widget.myController,
                autofocus: true,
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: kindigoThemeColor, width: 2.0),
                    ),
                    hintText: this.widget.hintText),
                onSubmitted: (value) {
                  if (this.widget.fieldToChange.toString().toLowerCase() ==
                      "name") {
                    changeName();
                  } else {
                    changeOtherFields();
                  }
                  Navigator.pop(context, () {
                    setState(() {});
                  });
                },
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CustomButton(
                        text: Text("Update"),
                        height: 70,
                        buttonColor: kindigoThemeColor,
                        width: double.infinity,
                        textColor: Colors.white,
                        onPress: () {
                          if (this
                                  .widget
                                  .fieldToChange
                                  .toString()
                                  .toLowerCase() ==
                              "name") {
                            changeName();
                          } else {
                            changeOtherFields();
                          }
                          Navigator.pop(context, () {
                            setState(() {});
                          });
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
