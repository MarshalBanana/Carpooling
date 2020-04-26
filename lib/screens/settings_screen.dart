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

//Future<Map<String, dynamic>> futureUserInfo;
Map<String, dynamic> userInfo = new Map<String, dynamic>();
AuthService _authService;
getUserInfo() async {
  final Firestore _db = Firestore.instance;

  String id = _authService.fUser.uid;
  print(id);

//  print("user info" + userInfo.toString());

  await _db.collection('users').document(id).get().then((value) {
    userInfo.addAll(value.data);
    // print("value" + value.data.toString());
    print("user info" + userInfo.toString());
//    return true;
  });
  return true;
}

logout() {
  print('in logout in home.dart');
  _authService.signOut();
}

// @override
// void initState() {
//   print("initstate");
//   getUserInfo();
// }

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    _authService = AuthService();
  }

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
          yetAnotherFutureBuilder(),
          ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                // ListTile(
                //   isThreeLine: true,
                //   leading: Icon(Icons.person),
                //   title: Text("Email"),
                //   subtitle: Text(
                //       userInfo['email']),
                // ),

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
                    height: MediaQuery.of(context).size.height / 16,
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
                    height: MediaQuery.of(context).size.height / 16,
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
                    buttonColor: Colors.red,
                    height: MediaQuery.of(context).size.height / 16,
                    onPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => getDialog(),
                        barrierDismissible: true,
                      );

//                      logout();
                    })
              ])
        ],
      )),
    );
  }

  getDialog() {
    return AlertDialog(
      title: Text(
          'Are you sure you want to logout? \n we won\'t remember you next time :('),
      elevation: 24.0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: <Widget>[
        Row(
          children: <Widget>[
            CustomButton(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 16,
              buttonColor: Colors.red,
              onPress: () {
                logout();
                Navigator.pop(context, 1);
              },
              text: Text('Yes'),
              textColor: Colors.white,
            ),
            CustomButton(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 16,
              buttonColor: Colors.grey[200],
              onPress: () {
                Navigator.pop(context, 1);
              },
              text: Text('No'),
              textColor: Colors.black,
            ),
          ],
        )
      ],
    );
  }

  yetAnotherFutureBuilder() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (userInfo != null) {
            return getSomeFutureInfo();
          } else {
            return getLoadingIcon(MediaQuery.of(context).size.height / 3);
          }
        } else
          return getLoadingIcon(MediaQuery.of(context).size.height / 3);
      },
      future: getUserInfo(),
//      initialData: ['loading', 'loading'],
    );
  }

  getSomeFutureInfo() {
    return Column(
      children: <Widget>[
        ListTile(
          isThreeLine: true,
          leading: Icon(Icons.person),
          title: Text("Full Name"),
          subtitle: Text(userInfo['firstname'] + " " + userInfo['lastname']),
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
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeInfoScreen(
                          hintText: "Enter Your Phone Number",
                          titleText: "Update Your Number",
                          descriptionText:
                              "Your number makes it easy for the Drivers to contact you",
                          userID: userInfo['id'],
                          fieldToChange: "phone_number",
                        )));
          },
        ),
        ListTile(
          isThreeLine: true,
          leading: Icon(Icons.star),
          title: Text("Your Rating"),
          subtitle: Text(userInfo['rating'].toString()),
        ),
      ],
    );
  }

  getLoadingIcon(double height) {
    return Container(
      child: Center(child: CircularProgressIndicator()),
      height: height,
    );
  }
}
