import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralQuestionModel {
  String id;
  String question;
  String answer;

  GeneralQuestionModel({this.id, this.question, this.answer});

  GeneralQuestionModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    question = doc['question'];
    answer = doc['answer'];
  }
}
