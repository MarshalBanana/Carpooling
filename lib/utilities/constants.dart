import 'package:flutter/material.dart';

const kforwardButtonColor = Color(0xFF95F204);
const kappBarColor = Color(0xFF8080FF);
const kboxColor = Color(0xFF81D3F8);
const kbottomNavBarHeight = 56;
const kTextFieldDecoration = InputDecoration(
  alignLabelWithHint: true,
  enabledBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  hintText: "Email",
  hintStyle: TextStyle(color: Colors.white60, fontSize: 15),
);
const kmediumTitleTextStyle = TextStyle(
    fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.w600);
const ktitleTextStyle =
    TextStyle(fontFamily: 'Montserrat', fontSize: 30, color: Colors.white);
const kTimePickTextStyle = TextStyle(
    fontFamily: 'Montserrat', fontSize: 15, fontWeight: FontWeight.w600);

 BoxDecoration kpastRidesBox = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [ Colors.white30,Colors.white]),
    shape: BoxShape.rectangle,
    border: Border.all(),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    color: kboxColor);
