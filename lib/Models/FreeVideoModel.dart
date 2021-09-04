import 'package:cloud_firestore/cloud_firestore.dart';

class FreeVideoModel {
  String id;
  String title;
  String videoLink;
  Timestamp time;

  FreeVideoModel({this.id, this.title, this.videoLink, this.time});

  FreeVideoModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    title = doc['title'];
    videoLink = doc['videoLink'];
    time = doc['time'];
  }
}
