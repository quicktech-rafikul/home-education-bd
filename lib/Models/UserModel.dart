import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String collegeName;
  String phoneNumber;
  String email;
  String lastExamName;
  int passingYear;
  String courseId;
  String bloodGroup;
  String profilePic;
  int point;
  int package;
  Timestamp time;

  UserModel({this.id, this.name, this.collegeName, this.phoneNumber, this.email, this.lastExamName, this.passingYear, this.courseId, this.bloodGroup, this.profilePic, this.point, this.package, this.time});

  UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    name = doc['name'];
    collegeName = doc['collegeName'];
    phoneNumber = doc['phoneNumber'];
    email = doc['email'];
    lastExamName = doc['lastExamName'];
    passingYear = doc['passingYear'];
    courseId = doc['courseId'];
    bloodGroup = doc['bloodGroup'];
    profilePic = doc['profilePic'];
    point = doc['point'];
    package = doc['package'];
    time = doc['time'];
  }
}
