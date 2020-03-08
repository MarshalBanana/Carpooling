import 'package:flutter/material.dart';

import 'constants.dart';

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
