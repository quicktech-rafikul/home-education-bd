import 'package:cloud_firestore/cloud_firestore.dart';

class PackageModel {
  String id;
  String courseId;
  String subjectId;
  String packageName;
  int totalSubscriber;
  String description;
  String advantages;
  int oldPrice;
  int newPrice;
  Timestamp time;

  PackageModel({this.id, this.courseId, this.subjectId, this.packageName, this.totalSubscriber, this.description, this.advantages, this.oldPrice, this.newPrice, this.time});

  PackageModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    courseId = doc['courseId'];
    subjectId = doc['subjectId'];
    packageName = doc['packageName'];
    totalSubscriber = doc['totalSubscriber'];
    description = doc['description'];
    advantages = doc['advantages'];
    oldPrice = doc['oldPrice'];
    newPrice = doc['newPrice'];
    time = doc['time'];
  }
}