import 'package:carpooling/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'utilities.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

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

  Future<FirebaseUser> emailSignIn(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    fUser = await _auth.currentUser();

    user = Observable(_auth.onAuthStateChanged);
    return fUser;
  }

  Future<FirebaseUser> emailSignUp(
      String email, String password, String phoneNumber) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      fUser = await _auth.currentUser();
      _id = fUser.uid;

      print("userid: " + _id);
      user = Observable(_auth.onAuthStateChanged);
    } catch (e) {
      print('below error from: authService + emailsignup()');
      print(e);

      return null;
    }

    bool isPhoneVerified = false;

    /** verifying user phone*/
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(minutes: 2),
        verificationCompleted: (AuthCredential credential) {
          /** linking user with his phone*/
          fUser.linkWithCredential(credential);
          isPhoneVerified = true;
        },
        verificationFailed: null,
        codeAutoRetrievalTimeout: (String verificationId) {},
        codeSent: null);

    /** check if email and phone are correct*/
    user = Observable(_auth.onAuthStateChanged);
    return ((fUser == null) || !isPhoneVerified) ? null : fUser;
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
    FirebaseUser user = await emailSignUp(email, password, phoneNumber);

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
      'rating': 4.5,
      'lastSeen': DateTime.now()
    });
  }

  getUserData() async {
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

  Stream<DocumentSnapshot> getUserDataStream() {
    String id = fUser.uid;
    print(id);

    return _db
        .collection('users')
        .document(id)
        .snapshots(includeMetadataChanges: false);
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
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
