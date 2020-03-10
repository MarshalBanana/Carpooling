import 'package:carpooling/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
//  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user; // firebase user
  FirebaseUser fUser;
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  String _id;
//  static final MyClass _singleton = new MyClass._internal();
//
//  factory MyClass() {
//    return _singleton;
//  }
//
//  MyClass._internal() {
//    ... // initialization logic here
//  }
  ///singleton variable
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

  Future<FirebaseUser> emailSignUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      fUser = await _auth.currentUser();
      _id = fUser.uid;
      print(_id);
      user = Observable(_auth.onAuthStateChanged);

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
      'rating': 4.5,
      'lastSeen': DateTime.now()
    });
  }

  getUserData() async {
    String id = fUser.uid;
    print(id);
//    print('????????? id: ' + _id);
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

    return ItemBox _db
        .collection('users')
        .document(id)
        .snapshots(includeMetadataChanges: false);
  }

//    _db.collection('users').getDocuments().then((QuerySnapshot snapshot) {
//      snapshot.documents.singleWhere(test)forEach((f) => print('${f.data}'));
//    });

//  Future<FirebaseUser> googleSignIn() async {
//    try {
//      loading.add(true);
//      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
//      GoogleSignInAuthentication googleAuth =
//          await googleSignInAccount.authentication;
//
//      final AuthCredential credential = GoogleAuthProvider.getCredential(
//        accessToken: googleAuth.accessToken,
//        idToken: googleAuth.idToken,
//      );
//
//      FirebaseUser user =
//          (await _auth.signInWithCredential(credential)) as FirebaseUser;
//      updateUserData(user);
//      print("user name: ${user.displayName}");
//
//      loading.add(false);
//      return user;
//    } catch (error) {
//      return error;
//    }
//  }

//  void updateUserData(FirebaseUser user) async {
//    DocumentReference ref = _db.collection('users').document(user.uid);
//
//    return ref.setData({
//      'uid': user.uid,
//      'email': user.email,
//      'displayName': user.displayName,
//      'lastSeen': DateTime.now()
//    }, merge: true);
//  }

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
