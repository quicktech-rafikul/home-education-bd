import 'package:cloud_firestore/cloud_firestore.dart';

class CentralTestExamModel {
  String id;
  String courseId;
  num duration;
  String examName;
  num totalQuestion;
  num totalMark;
  bool isNegative;
  num negativeMark;
  String questionLink;
  String startDate;
  String startTime;
  String endDate;
  String endTime;
  Timestamp time;

  CentralTestExamModel(
      {this.id,
      this.courseId,
      this.duration,
      this.examName,
      this.totalQuestion,
      this.totalMark,
      this.isNegative,
      this.negativeMark,
      this.questionLink,
      this.startDate,
      this.startTime,
      this.endDate,
      this.endTime,
      this.time});

  CentralTestExamModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    courseId = doc['courseId'];
    duration = doc['duration'];
    examName = doc['examName'];
    totalQuestion = doc['totalQuestion'];
    totalMark = doc['totalMark'];
    isNegative = doc['isNegative'];
    negativeMark = doc['negativeMark'];
    questionLink = doc['questionLink'];
    startDate = doc['startDate'];
    startTime = doc['startTime'];
    endDate = doc['endDate'];
    endTime = doc['endTime'];
    time = doc['time'];
  }
}
