import 'package:carpooling/screens/signin.dart';
import 'package:carpooling/utilities/auth_service.dart';
import 'package:carpooling/utilities/constants.dart';
import 'package:carpooling/utilities/utilities.dart';
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

enum Gender { Male, Female }

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  String _phoneNo;
//  String VerCode;
//  String VerId;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
  }

  AuthService _authService;
  FirebaseUser user;

  bool _loading = false;

  int _age;

  String _firstName;

  String _lastName;

  Gender _gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _loading
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/fullBackground.jpeg'),
                            fit: BoxFit.fill)),
                  ),
                  SingleChildScrollView(
                    child: Container(
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
                            height: 13,
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
                                  InputField(
                                    decoration: kTextFieldDecoration.copyWith(
                                        hintText: 'First Name'),
                                    onChanged: (value) {
                                      _firstName = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  InputField(
                                    decoration: kTextFieldDecoration.copyWith(
                                        hintText: 'Last Name'),
                                    onChanged: (value) {
                                      _lastName = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  TextField(
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      _email = value;
                                    },
                                    decoration: kTextFieldDecoration.copyWith(
                                      hintText: 'Email',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  InputField(
                                    obscureText: true,
                                    onChanged: (value) {
                                      _password = value;
                                    },
                                    decoration: kTextFieldDecoration.copyWith(
                                      hintText: 'Password',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  InputField(
                                    decoration: kTextFieldDecoration.copyWith(
                                        hintText: 'Age'),
                                    onChanged: (value) {
                                      _age = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  InputField(
                                    decoration: kTextFieldDecoration.copyWith(
                                        hintText: 'Phone Number'),
                                    onChanged: (value) {
                                      _phoneNo = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Male',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Radio(
                                      value: Gender.Male,
                                      groupValue: _gender,
                                      activeColor: kboxColor,
                                      onChanged: (value) {
                                        setState(() {
                                          _gender = value;
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Female',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Radio(
                                      activeColor: kboxColor,
                                      value: Gender.Female,
                                      groupValue: _gender,
                                      onChanged: (value) {
                                        setState(() {
                                          _gender = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      try {
                                        setState(() {
                                          _loading = true;
                                        });
//                                        user = await _authService.emailSignUp(
//                                            _email, _password);
//                                        user = await _authService.createNewUser(
//                                            _email,
//                                            _password,
//                                            _firstName,
//                                            _lastName,
//                                            _age,
//                                            _phoneNo,
//                                            _gender);
                                        user = await _authService.createNewUser(
                                          'ahmedemail@email.com',
                                          '123456',
                                          'ahmed',
                                          'robah',
                                          25,
                                          '5554567891',
                                          Gender.Male,
                                        );
//                                          final newUser = await _auth
//                                              .createUserWithEmailAndPassword(
//                                                  email: email.trim(),
//                                                  password: password);

                                        if (user != null) {
                                          print(user.email);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LoadingScreen(),
                                            ),
                                          );
                                        }

                                        setState(() {
                                          _loading = false;
                                        });
                                      } catch (e) {
                                        setState(() {
                                          _loading = false;
                                        });
                                        print('below error from: signup');
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
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(50),
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
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }
}
