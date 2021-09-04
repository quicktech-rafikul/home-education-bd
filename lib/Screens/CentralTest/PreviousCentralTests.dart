/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationbd/Models/CentralTestExamModel.dart';
import 'package:educationbd/Screens/Utils/BottomBar.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_PreviousCentralTests extends StatefulWidget {
  @override
  _QuickTechIT_PreviousCentralTestsState createState() =>
      _QuickTechIT_PreviousCentralTestsState();
}

class _QuickTechIT_PreviousCentralTestsState
    extends State<QuickTechIT_PreviousCentralTests> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> data = [];

  bool _isRequesting = false;
  bool _isFinish = false;

  static final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  String date = dateFormatter.format(DateTime.now());

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
        .collection('central_text_exam')
        .where('endDate', isLessThan: date)
        .where('courseId', isEqualTo: GetStorage().read('userCourse'))
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
          'Previous Tests',
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
          padding: const EdgeInsets.fromLTRB(0, 10, 00, 00),
          child: Column(
            children: [
              StreamBuilder<List<DocumentSnapshot>>(
                stream: _streamController.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    return Container(
                      height: 100,
                      child: Center(
                          child: Text(
                        "No Exams Available",
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2)),
                      )),
                    );
                  } else if (snapshot.data.length == 0) {
                    return Container(
                      height: 100,
                      child: Center(
                          child: Text(
                        "No Exams Available Today",
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2)),
                      )),
                    );
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: snapshot.data
                          .map<Widget>((DocumentSnapshot document) {
                        CentralTestExamModel model =
                            CentralTestExamModel.fromDocumentSnapshot(document);

                        return examItemUI(model);
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  examItemUI(CentralTestExamModel item) {
    return Container(
      child: Container(
        color: UIColors.bgc2,
        padding: EdgeInsets.all(8),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              child: Text(
                item.examName,
                style: TextStyle(
                    fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                    color: UIColors.textcolor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mark: ${item.totalMark}',
                  style: TextStyle(
                    fontSize: ResponsiveFlutter.of(context).fontSize(2),
                    color: UIColors.textcolor,
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Duration: ${item.duration}',
                        style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2),
                          color: UIColors.textcolor,
                        ),
                      ),
                      Text(
                        'Start Time: ${item.startTime}',
                        style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2),
                          color: UIColors.textcolor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(UIColors.primaryColor),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.fromLTRB(20, 5, 20, 5))),
                  onPressed: () {
                    Get.toNamed('/examPage/central/${item.id}');
                  },
                  child: Text(
                    "Attend Exam",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void requestNextPage() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;
      if (data.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('central_text_exam')
            .where('endDate', isLessThan: date)
            .where('courseId', isEqualTo: GetStorage().read('userCourse'))
            .limit(10)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('central_text_exam')
            .where('endDate', isLessThan: date)
            .where('courseId', isEqualTo: GetStorage().read('userCourse'))
            .startAfterDocument(data[data.length - 1])
            .limit(10)
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
