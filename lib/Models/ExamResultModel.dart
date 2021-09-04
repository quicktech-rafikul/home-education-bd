import 'package:cloud_firestore/cloud_firestore.dart';

class ExamResultModel {
  String id;
  String examId;
  String examName;
  String userId;
  String questionLink;
  int totalQuestion;
  int totalAnswer;
  int totalNoAnswer;
  int totalCorrectAnswer;
  int totalWrongAnswer;
  double mark;
  double negativeMark;
  Timestamp time;

  ExamResultModel({this.id, this.examId, this.examName, this.userId, this.questionLink, this.totalQuestion, this.totalAnswer, this.totalNoAnswer, this.totalCorrectAnswer, this.totalWrongAnswer, this.mark, this.negativeMark, this.time});

  ExamResultModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    examId = doc['examId'];
    examName = doc['examName'];
    userId = doc['userId'];
    questionLink = doc['questionLink'];
    totalQuestion = doc['totalQuestion'];
    totalAnswer = doc['totalAnswer'];
    totalNoAnswer = doc['totalNoAnswer'];
    totalCorrectAnswer = doc['totalCorrectAnswer'];
    totalWrongAnswer = doc['totalWrongAnswer'];
    mark = doc['mark'];
    negativeMark = doc['negativeMark'];
    time = doc['time'];
  }
}