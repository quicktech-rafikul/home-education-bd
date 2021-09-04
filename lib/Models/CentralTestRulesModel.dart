import 'package:cloud_firestore/cloud_firestore.dart';

class CentralTestRulesModel {
  String id;
  String title;
  String description;

  CentralTestRulesModel({this.id, this.title, this.description});

  CentralTestRulesModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    title = doc['title'];
    description = doc['description'];
  }
}
