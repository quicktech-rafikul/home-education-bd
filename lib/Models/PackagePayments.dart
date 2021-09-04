import 'package:cloud_firestore/cloud_firestore.dart';

class PackagePayments {
  String id;
  String packageId;
  String userId;
  String providerName;
  String providerNumber;
  int amount;
  String transactionId;
  bool accept;
  Timestamp acceptTime;
  bool reject;
  String rejectReason;
  Timestamp rejectTime;
  Timestamp time;

  PackagePayments({this.id, this.packageId, this.userId, this.providerName, this.providerNumber, this.amount, this.transactionId, this.accept, this.acceptTime, this.reject, this.rejectReason, this.rejectTime, this.time});

  PackagePayments.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    packageId = doc['packageId'];
    userId = doc['userId'];
    providerName = doc['providerName'];
    providerNumber = doc['providerNumber'];
    amount = doc['amount'];
    transactionId = doc['transactionId'];
    accept = doc['accept'];
    acceptTime = doc['acceptTime'];
    reject = doc['reject'];
    rejectReason = doc['rejectReason'];
    rejectTime = doc['rejectTime'];
    time = doc['time'];
  }
}
