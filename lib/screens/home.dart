import 'package:carpooling/screens/ride_information_screen.dart';
import 'package:carpooling/state/app_states.dart';
import 'package:flutter/material.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
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
                      'Home',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 30),
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
                'Recent Rides',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              StreamBuilder(
                  stream: _db.collection("user_auth").snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text(
                            "It appears something is wrong with the network");
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                        return Expanded(
                          child: new ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot riderInfo =
                                    snapshot.data.documents[index];
                                return Material(
                                    child: GestureDetector(
                                      onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RideInfoScreen(
                                                appState: appState,
                                              )),
                                    );
                                  },
                                                                          child: Container(
                                  decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        color: kboxColor),
                                  margin: EdgeInsets.all(4),
                                  height: 16,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(riderInfo["email"]),
                                        Text(riderInfo["mobile"])
                                        //Text(ds["user_id"].toString())
                                      ],
                                  ),
                                ),
                                    ));
                              }),
                        );
                      case ConnectionState.done:
                        return Text("sd");
                    }
                  }),
              Text(
                'People near You',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              StreamBuilder(
                  stream: _db.collection("user_auth").snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text(
                            "It appears something is wrong with the network");
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                        return Expanded(
                          child: new ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot riderInfo =
                                    snapshot.data.documents[index];
                                print("A" * 100);

                                return Material(                             
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        color: kboxColor),
                                    margin: EdgeInsets.all(4),
                                    height: 16,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(riderInfo["email"]),
                                        Text(riderInfo["mobile"]),
                                        // getUserInfo(riderInfo["user_id"]
                                        //     .toString()
                                        //     .substring(7))
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      case ConnectionState.done:
                        return Text("sd");
                    }
                  }),
              Container(
                child: CustomButton(
                  buttonColor: kforwardButtonColor,
                  onPress: () {},
                  text: Text(
                    'Schedule a Ride',
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

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();
    p.lineTo(size.width, 0);
    p.lineTo(size.width, size.height / 1.5);
//    p.cubicTo(0, 42, 20, 40, double.infinity, 42);
    p.cubicTo(
      size.width / 1.6,
      3 * size.height / 2.1,
      3 * size.width / 8,
      size.height / 1.6,
      0,
      size.height / 1.5,
    );
    p.lineTo(0, 0);
//    p.lineTo(0, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

//age can_drive first name last name is_male rating
getUserInfo(String userID) {
  // final Firestore _db = Firestore.instance;
  // //Stream document = _db .collection("user").snapshots();
  // Stream<DocumentSnapshot>  userInfo = _db.collection("users").document(userID).snapshots().;
  // //var document =  Firestore.instance.collection('users').document(userID).snapshots();

  // print("*"*80);
  // print(userInfo['age']);
  // print(document["firstname"]);
  // print(document["rating"]);
  // print("*"*80);
  // //return {'age': document["age"],'can_drive' : document["can_drive"]};
  // return "dsadasa";
  StreamBuilder(
      stream: Firestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(
            'No Data...',
          );
        } else {
          DocumentSnapshot items = snapshot.data.document(userID);
          print("B" * 100);
          print(items["age"]);
          return Text(items["age"]);
        }
      });
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
