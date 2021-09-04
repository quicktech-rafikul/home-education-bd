/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationbd/Models/CentralTestExamModel.dart';
import 'package:educationbd/Screens/Utils/BottomBar.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_CentralTests extends StatefulWidget {
  @override
  _QuickTechIT_CentralTestsState createState() =>
      _QuickTechIT_CentralTestsState();
}

class _QuickTechIT_CentralTestsState extends State<QuickTechIT_CentralTests> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> data = [];

  bool _isRequesting = false;
  bool _isFinish = false;

  static final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  String startDate = dateFormatter.format(DateTime.now());

  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((productChange) {
      if (productChange.type == DocumentChangeType.removed) {
        data.removeWhere((product) {
          return productChange.doc.id == product.id;
        });
        isChange = true;
      } else {
        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = data.indexWhere((product) {
            return productChange.doc.id == product.id;
          });

          if (indexWhere >= 0) {
            data[indexWhere] = productChange.doc;
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
        .where('startDate', isEqualTo: startDate)
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
            color: UIColors.textcolor,
            size: 20,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Central Tests',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.textcolor,
          ),
        ),
        backgroundColor: UIColors.bgc1,
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
      backgroundColor: UIColors.bgc1,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
            requestNextPage();
          }
          return true;
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: [
              Container(
                width: Get.width,
                child: Text(
                  "Today's Exam",
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
              StreamBuilder<List<DocumentSnapshot>>(
                stream: _streamController.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    return Container(
                      color: UIColors.bgc2,
                      height: 160,
                      child: Center(
                          child: Text(
                        "No Exams Available Today",
                        style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2),
                          color: UIColors.textcolor,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    );
                  } else if (snapshot.data.length == 0.0) {
                    return Container(
                      color: UIColors.bgc2,
                      height: 100,
                      child: Center(
                          child: Text(
                        "No Exams Available Today",
                        style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2),
                          color: UIColors.textcolor,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    );
                  } else {
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 130.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                      ),
                      items: snapshot.data
                          .map<Widget>((DocumentSnapshot document) {
                        CentralTestExamModel model =
                            CentralTestExamModel.fromDocumentSnapshot(document);
                        return examItemUI(model);
                      }).toList(),
                    );
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: Get.width,
                child: TextButton(
                    onPressed: () {
                      Get.toNamed('/centralTest/previous');
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(UIColors.bgc2),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(0, 20, 0, 20))),
                    child: Text(
                      "Previous Tests",
                      style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                          color: Colors.white),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: Get.width,
                child: TextButton(
                    onPressed: () {
                      Get.toNamed('/centralTest/rules');
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(UIColors.bgc2),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(0, 20, 0, 20))),
                    child: Text(
                      "Rules",
                      style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                          color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  examItemUI(CentralTestExamModel item) {
    return InkWell(
      onTap: () {
        Get.toNamed('/examPage/central/${item.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF485563),
              const Color(0xFF596164),
            ],
            begin: const FractionalOffset(0.0, 0.5),
            end: const FractionalOffset(1.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Container(
          //color: UIColors.bgc2,
          padding: EdgeInsets.only(top: 10, left: 20),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                child: Center(
                  child: Text(
                    item.examName,
                    style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                        color: UIColors.textcolor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mark: ${item.totalMark}',
                          style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).fontSize(2),
                            color: UIColors.textcolor,
                          ),
                        ),
                        Text(
                          'Eaxm Duration: ${item.duration} Minutes',
                          style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).fontSize(2),
                            color: UIColors.textcolor,
                          ),
                        ),
                        Text(
                          'End Time: ${item.startTime}',
                          style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).fontSize(2),
                            color: UIColors.textcolor,
                          ),
                        ),
                        Text(
                          'End Date: ${item.endDate} ',
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
            ],
          ),
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
            .where('startDate', isEqualTo: startDate)
            .where('courseId', isEqualTo: GetStorage().read('userCourse'))
            .limit(10)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('central_text_exam')
            .where('startDate', isEqualTo: startDate)
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
