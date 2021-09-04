import 'package:cloud_firestore/cloud_firestore.dart';

class LectureNoteModel {
  String id;
  String subjectId;
  String topicId;
  String title;
  String pdfLink;
  Timestamp time;

  LectureNoteModel({this.id, this.subjectId, this.topicId, this.title, this.pdfLink, this.time});

  LectureNoteModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    subjectId = doc['subjectId'];
    topicId = doc['topicId'];
    title = doc['title'];
    pdfLink = doc['pdfLink'];
    time = doc['time'];
  }
}
