/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationbd/Models/PackageModel.dart';
import 'package:educationbd/Models/PackagePayments.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_MyPackageDetails extends StatefulWidget {
  @override
  _QuickTechIT_MyPackageDetailsState createState() =>
      _QuickTechIT_MyPackageDetailsState();
}

class _QuickTechIT_MyPackageDetailsState
    extends State<QuickTechIT_MyPackageDetails> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String paymentId = Get.parameters['id'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          padding: EdgeInsets.all(15),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: UIColors.primaryColor2,
            size: 20,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Package Details',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.bgc2,
          ),
        ),
        backgroundColor: UIColors.backgroundColor,
        elevation: 0.0,
      ),
      backgroundColor: UIColors.backgroundColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('package_payment')
            .doc(paymentId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          PackagePayments item =
              PackagePayments.fromDocumentSnapshot(snapshot.data);

          return viewDetails(item);
        },
      ),
    );
  }

  viewDetails(PackagePayments item) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('package')
          .doc(item.packageId)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        PackageModel package = PackageModel.fromDocumentSnapshot(snapshot.data);
        return Center(
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width,
                    child: Text(
                      "Package Name",
                      style: TextStyle(
                        color: UIColors.primaryColor2,
                        fontSize: ResponsiveFlutter.of(context).fontSize(2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      package.packageName,
                      style: TextStyle(
                        color: UIColors.textcolor,
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      "Package Price",
                      style: TextStyle(
                        color: UIColors.primaryColor2,
                        fontSize: ResponsiveFlutter.of(context).fontSize(2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      package.newPrice.toString(),
                      style: TextStyle(
                        color: UIColors.primaryColor,
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      "Payment Provider",
                      style: TextStyle(
                        color: UIColors.primaryColor2,
                        fontSize: ResponsiveFlutter.of(context).fontSize(2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      item.providerName,
                      style: TextStyle(
                        color: UIColors.primaryColor,
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      "Payment Number",
                      style: TextStyle(
                        color: UIColors.primaryColor2,
                        fontSize: ResponsiveFlutter.of(context).fontSize(2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      item.providerNumber,
                      style: TextStyle(
                        color: UIColors.primaryColor,
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      "Payment Amount",
                      style: TextStyle(
                        color: UIColors.primaryColor2,
                        fontSize: ResponsiveFlutter.of(context).fontSize(2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      item.amount.toString(),
                      style: TextStyle(
                        color: UIColors.primaryColor,
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      "Transaction Id",
                      style: TextStyle(
                        color: UIColors.primaryColor2,
                        fontSize: ResponsiveFlutter.of(context).fontSize(2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      item.transactionId,
                      style: TextStyle(
                        color: UIColors.primaryColor,
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      item.accept
                          ? "Accept"
                          : item.reject
                              ? "Reject"
                              : "Pending",
                      style: TextStyle(
                        color: UIColors.primaryColor2,
                        fontSize: ResponsiveFlutter.of(context).fontSize(4.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (item.reject)
                    SizedBox(
                      height: 20,
                    ),
                  if (item.reject)
                    Container(
                      width: Get.width,
                      child: Text(
                        item.rejectReason,
                        style: TextStyle(
                          color: UIColors.primaryColor2,
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              )),
        );
      },
    );
  }
}
