/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationbd/Models/PackageModel.dart';
import 'package:educationbd/Models/PackagePayments.dart';
import 'package:educationbd/Screens/Utils/BottomBar.dart';
import 'package:educationbd/Screens/Utils/NavigationDrawer.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_MyPackageList extends StatefulWidget {
  @override
  _QuickTechIT_MyPackageListState createState() => _QuickTechIT_MyPackageListState();
}

class _QuickTechIT_MyPackageListState extends State<QuickTechIT_MyPackageList> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> data = [];

  bool _isRequesting = false;
  bool _isFinish = false;

  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((change) {
      if (change.type == DocumentChangeType.removed) {
        data.removeWhere((value) {
          return change.doc.id == value.id;
        });
        isChange = true;
      } else {
        if (change.type == DocumentChangeType.modified) {
          int indexWhere = data.indexWhere((value) {
            return change.doc.id == value.id;
          });

          if (indexWhere >= 0) {
            data[indexWhere] = change.doc;
          }
          isChange = true;
        }
      }
    });

    if (isChange) {
      _streamController.add(data);
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('package_payment')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();

    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
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
          'My Packages',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.primaryColor,
          ),
        ),
        backgroundColor: UIColors.backgroundColor,
        elevation: 0.0,
        // actions: <Widget>[
        //   IconButton(
        //     padding: EdgeInsets.all(15),
        //     icon: Icon(
        //       Icons.menu_rounded,
        //       color: UIColors.primaryColor2,
        //     ),
        //     onPressed: () {
        //       _scaffoldKey.currentState.openEndDrawer();
        //     },
        //   ),
        // ],
      ),
      // endDrawer: NavigationDrawer(),
      bottomNavigationBar: BottomBar(),
      backgroundColor: UIColors.backgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
            requestNextPage();
          }
          return true;
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: StreamBuilder<List<DocumentSnapshot>>(
            stream: _streamController.stream,
            builder: (BuildContext context,
                AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  // return Center(child: new CircularProgressIndicator());
                  if(snapshot == null){
                    return Center(child: new CircularProgressIndicator());
                  } else {
                    return Center(child: Text("You don't have any package"));
                  }
                  break;
                default:
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children:
                    snapshot.data.map<Widget>((DocumentSnapshot document) {
                      PackagePayments model =
                      PackagePayments.fromDocumentSnapshot(document);

                      return packageItemUI(model);
                    }).toList(),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  packageItemUI(PackagePayments item) {
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
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1),
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Get.toNamed('/package/my/${item.id}');
              },
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    child: Text(
                      package.packageName,
                      style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      item.accept ? "Accept" : item.reject ? "Reject" : "Pending",
                      style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void requestNextPage() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;
      if (data.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('package_payment')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .limit(20)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('package_payment')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .startAfterDocument(data[data.length - 1])
            .limit(20)
            .get();
      }

      if (querySnapshot != null) {
        int oldSize = data.length;
        data.addAll(querySnapshot.docs);
        int newSize = data.length;
        if (oldSize != newSize) {
          _streamController.add(data);
        } else {
          _isFinish = true;
        }
      }
      _isRequesting = false;
    }
  }
}
