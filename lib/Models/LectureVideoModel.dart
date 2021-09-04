import 'package:cloud_firestore/cloud_firestore.dart';

class LectureVideoModel {
  String id;
  String courseId;
  String subjectId;
  String topicId;
  String title;
  String videoLink;
  Timestamp time;

  LectureVideoModel({this.id, this.courseId, this.subjectId, this.topicId, this.title, this.videoLink, this.time});

  LectureVideoModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    courseId = doc['courseId'];
    subjectId = doc['subjectId'];
    topicId = doc['topicId'];
    title = doc['title'];
    videoLink = doc['videoLink'];
    time = doc['time'];
  }
}
