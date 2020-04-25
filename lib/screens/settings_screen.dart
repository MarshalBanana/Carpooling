import 'package:carpooling/screens/change_info_screen.dart';
import 'package:carpooling/screens/test_screen.dart';
import 'package:carpooling/screens/upcoming_rides_screen.dart';
import 'package:carpooling/utilities/auth_service.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:carpooling/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'past_rides_screen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

Map<String, dynamic> userInfo = new Map<String, dynamic>();

getUserInfo() async {
  final Firestore _db = Firestore.instance;
  AuthService _authService = AuthService();

  String id = _authService.fUser.uid;
  print(id);

  print("user info" + userInfo.toString());

  await _db.collection('users').document(id).get().then((value) {
    userInfo.addAll(value.data);
    // print("value" + value.data.toString());
    print("user info" + userInfo.toString());
    return userInfo;
  });
}

// @override
// void initState() {
//   print("initstate");
//   getUserInfo();
// }

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    getUserInfo();
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: ClipPath(
                clipper: AppBarClipper(),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  flexibleSpace: Image(
                    image: AssetImage('assets/fullBackground.jpeg'),
                    fit: BoxFit.cover,
                  ),
                  backgroundColor: kappBarColor,
                  title: Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 24),
                    ),
                  ),
                ),
              )),
          preferredSize: Size(
            double.infinity,
            MediaQuery.of(context).size.height / 6,
          )),
      body: Container(
          //height: double.maxFinite,
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Text("Profile",
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                  fontSize: 17,
                  fontWeight: FontWeight.w600)),
          ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  isThreeLine: true,
                  leading: Icon(Icons.person),
                  title: Text("Full Name"),
                  subtitle:
                      Text(userInfo['firstname'] + " " + userInfo['lastname']),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangeInfoScreen(
                                  hintText: "Enter Your Full Name",
                                  titleText: "Update Your Name",
                                  descriptionText:
                                      "Your name makes it easy for the Drivers to confirm who they pick up",
                                  userID: userInfo['id'],
                                  fieldToChange: "name",
                                )));
                  },
                ),
                ListTile(
                  isThreeLine: true,
                  leading: Icon(Icons.phone_android),
                  title: Text("Phone Number"),
                  subtitle: Text(userInfo['phone_number']),
                  onTap: (){
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeInfoScreen(
                                hintText: "Enter Your Phone Number",
                                titleText: "Update Your Number",
                                descriptionText: "Your number makes it easy for the Drivers to contact you",
                                userID: userInfo['id'],
                                fieldToChange: "phone_number",
                              )));
                  },
                ),
                // ListTile(
                //   isThreeLine: true,
                //   leading: Icon(Icons.person),
                //   title: Text("Email"),
                //   subtitle: Text(
                //       userInfo['email']),
                // ),
                ListTile(
                  isThreeLine: true,
                  leading: Icon(Icons.star),
                  title: Text("Your Rating"),
                  subtitle: Text(userInfo['rating'].toString()),
                ),
                CustomButton(
                    text: Text("Your Upcoming Rides",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 17,
                            fontWeight: FontWeight.w600)),
                    width: double.infinity,
                    textColor: Colors.white,
                    buttonColor: kindigoThemeColor,
                    height: 50,
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpcomingRidesScreen()));
                    }),
                CustomButton(
                    text: Text("Your Past Rides",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 17,
                            fontWeight: FontWeight.w600)),
                    width: double.infinity,
                    textColor: Colors.white,
                    buttonColor: kindigoThemeColor,
                    height: 50,
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PastRidesScreen()));
                    }),
                CustomButton(
                    text: Text("Logout",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 17,
                            fontWeight: FontWeight.w600)),
                    width: double.infinity,
                    textColor: Colors.white,
                    buttonColor: kindigoThemeColor,
                    height: 50,
                    onPress: () {
                      //TODO LOGOUT
                    })
              ])
        ],
      )),
    );
  }
}
