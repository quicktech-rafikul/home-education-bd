/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationbd/Models/PackageModel.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_PackageDetails extends StatefulWidget {
  @override
  _QuickTechIT_PackageDetailsState createState() =>
      _QuickTechIT_PackageDetailsState();
}

class _QuickTechIT_PackageDetailsState
    extends State<QuickTechIT_PackageDetails> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String packageId = Get.parameters['id'];

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
            color: UIColors.textcolor,
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
            color: UIColors.textcolor,
          ),
        ),
        backgroundColor: UIColors.bgc1,
        elevation: 0.0,
      ),
      backgroundColor: UIColors.bgc1,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('package')
            .doc(packageId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          PackageModel item = PackageModel.fromDocumentSnapshot(snapshot.data);

          return viewDetails(item);
        },
      ),
    );
  }

  viewDetails(PackageModel item) {
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: [
            Container(
              height: 60,
              color: UIColors.bgc2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: Get.width,
                      child: Text(
                        item.packageName,
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2.5),
                            color: UIColors.textcolor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: Get.width,
                      child: Text(
                        'Subscriber : ${item.totalSubscriber}',
                        style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2),
                          color: UIColors.textcolor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width,
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(3),
                  color: UIColors.textcolor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: Get.width,
              child: Text(
                item.description,
                style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(2),
                  color: UIColors.textcolor,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width,
              child: Text(
                'Advantages',
                style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(3),
                  color: UIColors.textcolor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: Get.width,
              child: Text(
                item.advantages,
                style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(2),
                  color: UIColors.textcolor,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Price:',
                    style: TextStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                      color: UIColors.textcolor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${item.oldPrice} ৳',
                    style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${item.newPrice} ৳',
                    style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                        color: UIColors.textcolor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: Get.width,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(UIColors.primaryColor)),
                child: Text(
                  "Buy Now",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Get.toNamed('/payment/$packageId');
                },
              ),
            )
          ],
        ));
  }
}
