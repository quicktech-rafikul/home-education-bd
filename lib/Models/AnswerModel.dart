import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerModel {
  String answer;
  String correctAnswer;

  AnswerModel({this.answer, this.correctAnswer});

  AnswerModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    answer = doc['answer'];
    correctAnswer = doc['correctAnswer'];
  }
}
