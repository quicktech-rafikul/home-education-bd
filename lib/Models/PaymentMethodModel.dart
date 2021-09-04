import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodModel {
  String id;
  String provider;
  String number;

  PaymentMethodModel({this.id, this.provider, this.number});

  PaymentMethodModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    provider = doc['provider'];
    number = doc['number'];
  }
}
