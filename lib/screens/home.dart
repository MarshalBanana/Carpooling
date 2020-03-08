import 'package:flutter/material.dart';
import 'package:carpooling/utilities/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: ClipPath(
                clipper: AppBarClipper(),
                child: AppBar(
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
              Text(
                'People near You',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
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
