import 'package:carpooling/utilities/auth_service.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:carpooling/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestUserDataScreen extends StatefulWidget {
  @override
  _TestUserDataScreenState createState() => _TestUserDataScreenState();
}

class _TestUserDataScreenState extends State<TestUserDataScreen> {
  AuthService _authService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authService = AuthService();
  }
@override
Widget build(BuildContext context) {
  return Container(child:Text("Tobe be implemented"));
}
  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder<Widget>(
  //     stream: _authService.getUserDataStream(),
  //   );
  // }

  Future<Widget> getUserList() async {
    Stream<DocumentSnapshot> docStream = await _authService.getUserDataStream();

    Column c = Column();
    Row r = Row();
    docStream.forEach((document) {
      document.data.forEach((var key, var value) {
        r.children.add(
          ItemBox(
            children: <Widget>[Text(key)],
          ),
        );
        r.children.add(
          ItemBox(
            children: <Widget>[Text(value)],
          ),
        );
        c.children.add(r);
      });
    });

    return r;
  }
}

class TempBox extends StatelessWidget {
  TempBox({this.child});

  final String child;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: kboxColor,
      child: Container(
        height: MediaQuery.of(context).size.height / 7,
        child: Text(child),
      ),
    );
  }
}
