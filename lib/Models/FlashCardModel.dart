import 'package:cloud_firestore/cloud_firestore.dart';

class FlashCardModel {
  String id;
  String subjectId;
  String topicId;
  String title;
  String imageLink;
  Timestamp time;

  FlashCardModel({this.id, this.subjectId, this.topicId, this.title, this.imageLink, this.time});

  FlashCardModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    subjectId = doc['subjectId'];
    topicId = doc['topicId'];
    title = doc['title'];
    imageLink = doc['imageLink'];
    time = doc['time'];
  }
}
