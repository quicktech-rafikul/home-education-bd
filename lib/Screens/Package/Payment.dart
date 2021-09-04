/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationbd/Models/PackageModel.dart';
import 'package:educationbd/Models/PackagePayments.dart';
import 'package:educationbd/Models/PaymentMethodModel.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_Payment extends StatefulWidget {
  @override
  _QuickTechIT_PaymentState createState() => _QuickTechIT_PaymentState();
}

class _QuickTechIT_PaymentState extends State<QuickTechIT_Payment> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String packageId = Get.parameters['packageId'];

  TextEditingController transactionController = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<PaymentMethodModel> providers = [];

  @override
  void initState() {
    Database().getPaymentProviders().then((value) {
      setState(() {
        providers = value;
      });
    });
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
          'Payment',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.primaryColor,
          ),
        ),
        backgroundColor: UIColors.backgroundColor,
        elevation: 0.0,
      ),
      backgroundColor: UIColors.backgroundColor,
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

          return view(item);
        },
      ),
    );
  }

  view(PackageModel item){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        children: [
          Text(
            item.packageName,
            style: TextStyle(
                fontSize: ResponsiveFlutter.of(context).fontSize(3)),
          ),
          SizedBox(height: 10,),
          Text(
            item.newPrice.toString(),
            style: TextStyle(
                fontSize: ResponsiveFlutter.of(context).fontSize(4), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 50,),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: providers.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return ListTile(
                  onTap: () {
                    transactionController.clear();
                    Get.defaultDialog(
                        title: "Payment",
                        content: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: [
                                          Container(
                                              width: Get.width,
                                              child: Text("Provider:",textAlign: TextAlign.right,)),
                                          Container(
                                              width: Get.width,
                                              child: Text("Number:",textAlign: TextAlign.right,)),
                                          Container(
                                              width: Get.width,
                                              child: Text("Amount:",textAlign: TextAlign.right,)),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          Container(
                                              width: Get.width, child: Text(providers[index].provider)),
                                          Container(
                                              width: Get.width,
                                              child: Text(providers[index].number)),
                                          Container(
                                              width: Get.width,
                                              child: Text("${item.newPrice} ৳")),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: transactionController,
                                validator: (phone) {
                                  if (phone.length == 0) {
                                    return 'Please enter Valid Transaction Id';
                                  }
                                  else
                                    return null;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Transaction ID',
                                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: UIColors.primaryColor, width: 1),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30,),
                            TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(20, 8, 20, 8)),
                                  backgroundColor: MaterialStateProperty.all(UIColors.primaryColor)
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  PackagePayments model = new PackagePayments(
                                    packageId: item.id,
                                    userId: FirebaseAuth.instance.currentUser.uid,
                                    providerName: providers[index].provider,
                                    providerNumber: providers[index].number,
                                    amount: item.newPrice,
                                    transactionId: transactionController.text,
                                  );

                                  await Database().createPackagePayment(model).then((value) {
                                    Get.offAndToNamed('/packages/my');
                                  });

                                }
                              },
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    fontSize:
                                    ResponsiveFlutter.of(context).fontSize(2.2),
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ));
                  },
                  title: Text(
                    providers[index].provider,
                    style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.2)),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
