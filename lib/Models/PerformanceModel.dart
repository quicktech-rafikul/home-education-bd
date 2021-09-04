import 'package:cloud_firestore/cloud_firestore.dart';

class PerformanceModel {
  String id;
  int totalAttendExam;
  int totalQuestion;
  int totalCorrectAnswer;
  int totalWrongAnswer;
  int totalAnswer;
  int totalNoAnswer;
  double totalMark;

  PerformanceModel({this.id, this.totalAttendExam, this.totalQuestion, this.totalCorrectAnswer, this.totalWrongAnswer, this.totalAnswer, this.totalNoAnswer, this.totalMark});

  PerformanceModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    totalAttendExam = doc['totalAttendExam'];
    totalQuestion = doc['totalQuestion'];
    totalCorrectAnswer = doc['totalCorrectAnswer'];
    totalWrongAnswer = doc['totalWrongAnswer'];
    totalAnswer = doc['totalAnswer'];
    totalNoAnswer = doc['totalNoAnswer'];
    totalMark = doc['totalMark'];
  }
}
