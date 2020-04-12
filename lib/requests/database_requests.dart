import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carpooling/utilities/auth_service.dart';

final AuthService a = AuthService();
final Firestore _db = Firestore.instance;
Stream currentUser = a.getUserDataStream();
Firestore get db => _db;

 getUserInfo() { 
print("get User Info");
  String name ="";
  print("name: " + name);
  String phoneNum;
  String rating ;
  String gender;
  final subscription = currentUser.listen(
    (data){
            print("entered Stream");
            name = data["firstname"] + " " + data["lastname"];
            phoneNum = data["phone_number"];
            rating = data["rating"];
            if(data["is_male"]){
              gender = "Male";
            }
            else{
              gender = "Female";
            }
    }
  );
  //return [name,phoneNum,rating,gender];
  print([name,phoneNum,rating,gender]);
}
