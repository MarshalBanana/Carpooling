import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

const Color yellow = Colors.yellow;
const Color white = Colors.white;

class InputField extends StatelessWidget {
  InputField(
      {@required this.onChanged, @required this.decoration, this.obscureText});

  final Function onChanged;
  final InputDecoration decoration;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText != null ? obscureText : false,
      style: TextStyle(
        color: Colors.white,
      ),
      onChanged: (value) {
        onChanged(value);
      },
      decoration: decoration,
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
            onPressed: onPress, minWidth: width, height: height, child: text),
      ),
    );
  }
}

class ItemBox extends StatelessWidget {
  ItemBox({this.children});

  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: kboxColor,
      child: Container(
        height: MediaQuery.of(context).size.height / 5.5,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
