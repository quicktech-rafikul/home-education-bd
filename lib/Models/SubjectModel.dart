import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  String id;
  String title;
  String courseId;
  bool isPremium;

  SubjectModel({this.id, this.title, this.courseId, this.isPremium});

  SubjectModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    title = doc['title'];
    courseId = doc['courseId'];
    isPremium = doc['isPremium'];
  }
}
