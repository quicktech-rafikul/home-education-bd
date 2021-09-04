import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  String id;
  String courseId;
  String subjectId;
  String topicId;
  String title;
  String pdfLink;
  Timestamp time;

  NoticeModel({this.id, this.courseId, this.subjectId, this.topicId, this.title, this.pdfLink, this.time});

  NoticeModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    courseId = doc['courseId'];
    subjectId = doc['subjectId'];
    topicId = doc['topicId'];
    title = doc['title'];
    pdfLink = doc['pdfLink'];
    time = doc['time'];
  }
}
