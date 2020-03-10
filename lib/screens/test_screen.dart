import 'package:carpooling/utilities/auth_service.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:carpooling/utilities/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  FirebaseUser currentUser;
  AuthService _authService = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authService = AuthService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: MyCustomPainter(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipPath(
                clipper: AppBarClipper(),
                child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 6.5,
                    color: kappBarColor,
                    child: Padding(
                      padding: EdgeInsets.only(left: 40, top: 20),
                      child: Text('Home', style: ktitleTextStyle),
                    )),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Recent Rides',
                        style: kmediumTitleTextStyle,
                      ),
                      Row(
                        children: <Widget>[
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            color: kboxColor,
                            child: Container(
                              height: MediaQuery.of(context).size.height / 5.5,
                              child: Column(
                                children: <Widget>[
                                  Text('sadfasgasga'),
                                  Text('sadfasgasga'),
                                  Text('sadfasgasga'),
                                  Text('sadfasgasga'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                      Text(
                        'People near You',
                        textAlign: TextAlign.left,
                        style: kmediumTitleTextStyle,
                      ),
                      Row(
                        children: <Widget>[
                          ItemBox(
                            children: <Widget>[
                              Text('sadfasgasga'),
                              Text('sadfasgasga'),
                              Text('sadfasgasga'),
                              Text('sadfasgasga'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 11),
                  child: CustomButton(
                    buttonColor: kforwardButtonColor,
                    onPress: () async {
                      currentUser = await _authService.getCurrentUser();
                      _authService.getUserData();
                      print('-????????-');

                      await _authService.getUserData();
                    },
                    text: Text(
                      'Schedule a Ride',
                      style: kmediumTitleTextStyle,
                    ),
                    height: MediaQuery.of(context).size.height / 6,
                    textColor: Colors.black,
                    width: double.infinity,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint testPainter = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    Paint myPainter = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.indigo[50];

    Path p = Path();
    p.lineTo(size.width / 4, 0);
    p.cubicTo(
      size.width / 4,
      3 * size.height / 4,
      3 * size.width / 4,
      size.height / 4,
      3 * size.width / 4,
      size.height,
    );
    p.lineTo(0, size.height);
    p.lineTo(0, 0);
    p.close();

    canvas.drawPath(p, myPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
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
