import 'package:cloud_firestore/cloud_firestore.dart';

class MCQPreparationModel {
  String id;
  String courseId;
  String subjectId;
  String topicId;
  int duration;
  String examName;
  int totalQuestion;
  int totalMark;
  bool isNegative;
  double negativeMark;
  String questionLink;
  Timestamp time;

  MCQPreparationModel({this.id, this.courseId, this.subjectId, this.topicId, this.duration, this.examName, this.totalQuestion, this.totalMark, this.isNegative, this.negativeMark, this.questionLink, this.time});

  MCQPreparationModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    courseId = doc['courseId'];
    subjectId = doc['subjectId'];
    topicId = doc['topicId'];
    duration = doc['duration'];
    examName = doc['examName'];
    totalQuestion = doc['totalQuestion'];
    totalMark = doc['totalMark'];
    isNegative = doc['isNegative'];
    negativeMark = doc['negativeMark'];
    questionLink = doc['questionLink'];
    time = doc['time'];
  }
}