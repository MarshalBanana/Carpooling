import 'package:carpooling/screens/signin.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:rest_app/screens/signin.dart';
//import 'package:rest_app/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'loading_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const id = 'sign_up_screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email, password;
  String phoneNo;
  String VerCode;
  String VerId;

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _loading
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width,
                  height:
                      MediaQuery.of(context).size.height - kbottomNavBarHeight,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.asset(
                          'assets/background.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                                child: Image.asset(
                              'assets/logo.png',
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                            )),
                            SizedBox(
                              height: 13,
                            ),
                            Text(
                              "CAPP",
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: 27,
                                      color: Colors.white,
                                      letterSpacing: 1)),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              "Sign Up",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontSize: 23,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Your Ride Awaits",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: Colors.white70,
                                      letterSpacing: 1,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Form(
                              key: _formKey,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 45),
                                child: Column(
                                  children: <Widget>[
                                    TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (value) {
                                        email = value;
                                      },
                                      decoration: kTextFieldDecoration.copyWith(
                                        hintText: 'Enter Your Email',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    TextField(
                                      obscureText: true,
                                      onChanged: (value) {
                                        password = value;
                                      },
                                      decoration: kTextFieldDecoration.copyWith(
                                        hintText: 'Enter Your Password',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        try {
//                  print(email);
//                  print(password);
                                          setState(() {
                                            _loading = true;
                                          });
                                          final newUser = await _auth
                                              .createUserWithEmailAndPassword(
                                                  email: email.trim(),
                                                  password: password);

                                          if (newUser != null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoadingScreen()));
                                          }

                                          setState(() {
                                            _loading = false;
                                          });
                                        } catch (e) {
                                          setState(() {
                                            _loading = false;
                                          });
                                          print(e);
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 0),
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Text(
                                          "CREATE ACCOUNT",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  letterSpacing: 1)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInScreen()));
                              },
                              child: Text(
                                "Already have an account?",
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        decoration: TextDecoration.underline,
                                        letterSpacing: 0.5)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
