import 'package:cloud_firestore/cloud_firestore.dart';

class SliderModel {
  String id;
  String imageUrl;

  SliderModel({this.id, this.imageUrl});

  SliderModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    imageUrl = doc['imageUrl'];
  }
}
