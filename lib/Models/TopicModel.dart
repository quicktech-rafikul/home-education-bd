import 'package:cloud_firestore/cloud_firestore.dart';

class TopicModel {
  String id;
  String title;
  String subjectId;

  TopicModel({this.id, this.title, this.subjectId});

  TopicModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    title = doc['title'];
    subjectId = doc['subjectId'];
  }
}
