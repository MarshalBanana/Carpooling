import 'package:carpooling/utilities/http_handler.dart';
import 'package:flutter/material.dart';

class DemoRegisterScreen extends StatefulWidget {
  @override
  _DemoRegisterScreenState createState() => _DemoRegisterScreenState();
}

class _DemoRegisterScreenState extends State<DemoRegisterScreen> {
  HttpHandler handler = HttpHandler(
      url:
          'https://us-central1-carpooling-2d547.cloudfunctions.net/helloWorld');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: RaisedButton(
                child: Text('add a test user to database'),
                onPressed: () async {
                  await handler.testURL();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
