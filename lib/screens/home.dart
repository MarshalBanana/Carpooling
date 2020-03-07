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

class TestPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint testPainter = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    Path p = Path();
    p.lineTo(size.width, 0);
    p.lineTo(size.width, size.height / 1.5);
//    p.cubicTo(0, 42, 20, 40, double.infinity, 42);
    p.cubicTo(
      size.width / 1.5,
      3 * size.height / 2,
      3 * size.width / 8,
      size.height / 2,
      0,
      size.height / 2,
    );
    p.lineTo(0, 0);
//    p.lineTo(0, 0);
    p.close();

    canvas.drawPath(p, testPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class AppBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint myPainter = Paint()
      ..style = PaintingStyle.fill
      ..color = kappBarColor;

    Paint testPainter = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

//    canvas.drawLine(Offset.zero, Offset(0, 20), myPainter);
//    canvas.drawArc(
//        Rect.fromPoints(
//          Offset(0, 30),
//          Offset(double.infinity, 20),
//        ),
//        30,
//        20,
//        true,
//        myPainter);
//    canvas.drawLine(
//        Offset(double.infinity, 20), Offset(double.infinity, 0), myPainter);

    Path p = Path();
    p.lineTo(size.width, 0);
    p.lineTo(size.width, size.height / 1.5);
//    p.cubicTo(0, 42, 20, 40, double.infinity, 42);
    p.cubicTo(
      size.width / 1.5,
      3 * size.height / 2,
      3 * size.width / 8,
      size.height / 2,
      0,
      size.height / 2,
    );
    p.lineTo(0, 0);
//    p.lineTo(0, 0);
    p.close();

    canvas.drawPath(p, myPainter);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    // TODO: implement shouldRepaint
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
