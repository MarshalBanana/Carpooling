import 'package:carpooling/screens/ride_information_screen.dart';
import 'package:carpooling/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  SharedPreferences prefs;
  Observable<FirebaseUser> user; // firebase user
  FirebaseUser fUser;

  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  String _id;
  static final AuthService _singleAuth = AuthService._internal();

  ///singleton initialization
  factory AuthService() {
    return _singleAuth;
  }

  /// constructor
  AuthService._internal() {
    user = Observable(_auth.onAuthStateChanged);
    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        print('constructor: user signed in!');
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        print('constructor: user not signed in!');
        return Observable.just({});
      }
    });
  }

  Future<FirebaseUser> getCurrentUser() async {
    fUser = await _auth.currentUser();
    return fUser;
  }

  bool isBusy = false;

  Future<FirebaseUser> emailSignIn(String email, String password) async {
    isBusy = true;

    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString('password', password);

    print("saved email:" + prefs.getString("email"));

    fUser = await _auth.currentUser();
    user = Observable(_auth.onAuthStateChanged);
    isBusy = false;
    return fUser;
  }

  Future<FirebaseUser> emailSignUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      fUser = await _auth.currentUser();
      _id = fUser.uid;
      print(_id);
      user = Observable(_auth.onAuthStateChanged);

      prefs = await SharedPreferences.getInstance();
      prefs.setString("email", email);
      prefs.setString('password', password);

      return fUser;
    } catch (e) {
      print('below error from: authService + emailsignup()');
      print(e);
      return null;
    }
  }

  Future<FirebaseUser> createNewUser(
    String email,
    String password,
    String firstName,
    String lastName,
    int age,
    String phoneNumber,
    Gender gender,
  ) async {
    FirebaseUser user = await emailSignUp(email, password);

    bool isMale = gender == Gender.Male ? true : false;
    await createUserData(firstName, lastName, age, isMale, phoneNumber, user);
    return fUser;
  }

  createUserData(String firstName, String lastName, int age, bool isMale,
      String phoneNumber, user) {
    String id = user.uid;
    DocumentReference ref = _db.collection('users').document(id);
    ref.setData({
      'id': id,
      'firstname': firstName,
      'lastname': lastName,
      'phone_number': phoneNumber,
      'age': age,
      'is_male': isMale,
      'rating': 5,
      'lastSeen': DateTime.now()
    });
  }

  void getUserData() async {
    String id = fUser.uid;
    print(id);
    Stream<DocumentSnapshot> docStream = _db
        .collection('users')
        .document(id)
        .snapshots(includeMetadataChanges: false);

    print(docStream);
    docStream.forEach((value) {
      value.data.forEach((var val, var x) {
        print(val.toString() + ":" + x.toString());
      });
    });
  }

  Map<String, dynamic> getUserDetails() {
    String id = fUser.uid;
    print(id);
    Stream<DocumentSnapshot> docStream = _db
        .collection('users')
        .document(id)
        .snapshots(includeMetadataChanges: false);
    Map<String, dynamic> userInfo = Map<String, dynamic>();
    //new Map<String, dynamic>();
    print("user info" + userInfo.toString());

    print(docStream);
    docStream.forEach((value) {
      print("value" + value.data.toString());
      userInfo.addAll(value.data);
    });
    print("user info" + userInfo.toString());
    return userInfo;
  }

  // value.data.forEach((String val, dynamic x) {
  //   if(val.toString() == "lastSeen"){
  //     x = x.toDate();
  //   }
  //   print(val.toString() + ":" + x.toString());
  //   try{userInfo.putIfAbsent(val.toString(),x.toString());}
  //   catch(e){
  //     print(e);
  //   }

  Stream<DocumentSnapshot> getUserDataStream() {
    String id = fUser.uid;
    print(id);

    return _db
        .collection('users')
        .document(id)
        .snapshots(includeMetadataChanges: false)
        .asBroadcastStream();
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      prefs.setString('email', null);
      prefs.setString('password', null);
      return 'SignOut';
    } catch (e) {
      print('below error from: authService + signout');
      print(e);
      return e.toString();
    }
  }
}
//
//// TODO refactor global to InheritedWidget
//final AuthService authService = AuthService();
