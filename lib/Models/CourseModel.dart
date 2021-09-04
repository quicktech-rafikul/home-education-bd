import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  String id;
  String title;

  CourseModel({this.id, this.title});

  CourseModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    title = doc['title'];
  }
}
