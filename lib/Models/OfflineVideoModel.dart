import 'package:cloud_firestore/cloud_firestore.dart';

class OfflineVideoModel {
  String id;
  String title;
  String videoLink;

  OfflineVideoModel({this.id, this.title, this.videoLink});
}
