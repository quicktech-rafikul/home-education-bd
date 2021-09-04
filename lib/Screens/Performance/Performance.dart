/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationbd/Models/ExamResultModel.dart';
import 'package:educationbd/Models/PerformanceModel.dart';
import 'package:educationbd/Models/UserModel.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_Performance extends StatefulWidget {
  @override
  _QuickTechIT_PerformanceState createState() =>
      _QuickTechIT_PerformanceState();
}

class _QuickTechIT_PerformanceState extends State<QuickTechIT_Performance> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  PerformanceModel performance;
  UserModel user;

  int totalAttendExam = 0;
  int totalQuestion = 0;
  int totalCorrectAnswer = 0;
  int totalWrongAnswer = 0;
  int totalAnswer = 0;
  int totalNoAnswer = 0;
  double totalMark = 0;
  double accuracy = 0;
  double wrongRate = 0;
  double averageMark = 0;

  StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> data = [];

  bool _isRequesting = false;
  bool _isFinish = false;

  String userId = FirebaseAuth.instance.currentUser.uid;

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

    if (mounted) {
      if (isChange) {
        _streamController.add(data);
      }
    }
  }

  @override
  void initState() {
    Database().getUserData().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
    Database().getUserPerformance().then((value) {
      if (mounted) {
        setState(() {
          performance = value;
          totalAttendExam = performance.totalAttendExam;
          totalQuestion = performance.totalQuestion;
          totalCorrectAnswer = performance.totalCorrectAnswer;
          totalWrongAnswer = performance.totalWrongAnswer;
          totalAnswer = performance.totalAnswer;
          totalNoAnswer = performance.totalNoAnswer;
          totalMark = performance.totalMark;

          if (totalMark == 0 || totalAnswer == 0) {
            averageMark = 0;
            accuracy = 0;
            wrongRate = 0;
          } else {
            averageMark = totalMark / totalAnswer;
            accuracy = (totalCorrectAnswer / totalAnswer) * 100;
            wrongRate = (totalWrongAnswer / totalAnswer) * 100;
          }

          dataMap = {
            "Accuracy": accuracy,
            "Wrong": wrongRate,
          };
        });
      }
    });

    FirebaseFirestore.instance
        .collection('exam_result')
        .where('userId', isEqualTo: userId)
        .orderBy('time', descending: true)
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

  Map<String, double> dataMap = {
    "Accuracy": 0,
    "Wrong": 0,
  };

  List<Color> colorList = [
    Colors.green,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          'Profile',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.textcolor,
          ),
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.all(15),
            icon: Icon(
              Icons.edit_outlined,
              color: UIColors.textcolor,
            ),
            onPressed: () {
              Get.toNamed('/profile/edit');
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: UIColors.bgc1,
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.maxScrollExtent ==
                scrollInfo.metrics.pixels) {
              requestNextPage();
            }
            return true;
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: UIColors.bgc2,
                  ),
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200.0),
                          child: user == null
                              ? Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.white,
                                )
                              : Image.network(user.profilePic),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                user == null ? "" : user.name,
                                style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(2.2),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              child: Text(
                                user == null ? "" : user.email,
                                style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(2.0),
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: UIColors.bgc2,
                  ),
                  child: PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 1800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    colorList: colorList,
                    initialAngleInDegree: 270,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 26,
                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: UIColors.textcolor,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: false,
                      showChartValues: false,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: UIColors.bgc2,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Container(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    color: UIColors.bgc1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: UIColors.bgc1,
                                      ),
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 0, 15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            totalAnswer.toString(),
                                            style: TextStyle(
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(3),
                                                color: UIColors.textcolor),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Total Answer",
                                            style: TextStyle(
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(2),
                                                color: UIColors.textcolor),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    color: UIColors.bgc1,
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 0, 15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            totalCorrectAnswer.toString(),
                                            style: TextStyle(
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(3),
                                                color: UIColors.textcolor),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Right Answer",
                                            style: TextStyle(
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(2),
                                                color: UIColors.textcolor),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    color: UIColors.bgc1,
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 0, 15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            totalWrongAnswer.toString(),
                                            style: TextStyle(
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(3),
                                                color: UIColors.textcolor),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Wrong Answer",
                                            style: TextStyle(
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(2),
                                                color: UIColors.textcolor),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Card(
                                color: UIColors.bgc1,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        totalAttendExam.toString(),
                                        style: TextStyle(
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(3),
                                            color: UIColors.textcolor),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Attend Exam",
                                        style: TextStyle(
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(2),
                                            color: UIColors.textcolor),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Card(
                                color: UIColors.bgc1,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        averageMark.toString(),
                                        style: TextStyle(
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(3),
                                            color: UIColors.textcolor),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Average Mark",
                                        style: TextStyle(
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(2),
                                            color: UIColors.textcolor),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Card(
                                color: UIColors.bgc1,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${wrongRate.toString()}%',
                                        style: TextStyle(
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(3),
                                            color: UIColors.textcolor),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Wrong Rate",
                                        style: TextStyle(
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(2),
                                            color: UIColors.textcolor),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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
                        height: 100,
                        child: Center(
                            child: Text(
                          "No Exams Available Today",
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
                          ExamResultModel model =
                              ExamResultModel.fromDocumentSnapshot(document);

                          return previousExamItemUI(model);
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  previousExamItemUI(ExamResultModel item) {
    return Card(
      color: UIColors.bgc2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Container(
        padding: EdgeInsets.all(8),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              child: Text(
                item.examName,
                style: TextStyle(
                    color: UIColors.textcolor,
                    fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: Get.width,
              child: Text(
                'Submitted on: ${DateFormat.yMMMd().format(item.time.toDate())}, ${DateFormat.jm().format(item.time.toDate())}',
                style: TextStyle(
                    color: UIColors.textcolor,
                    fontSize: ResponsiveFlutter.of(context).fontSize(2)),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Column(
                    children: [
                      Text(
                        item.mark.toString(),
                        style: TextStyle(
                            color: UIColors.textcolor,
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2)),
                      ),
                      Text(
                        "Mark",
                        style: TextStyle(
                            color: UIColors.textcolor,
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8)),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Column(
                    children: [
                      Text(
                        item.totalCorrectAnswer.toString(),
                        style: TextStyle(
                            color: UIColors.textcolor,
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2)),
                      ),
                      Text(
                        "Correct",
                        style: TextStyle(
                            color: UIColors.textcolor,
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8)),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Column(
                    children: [
                      Text(
                        item.totalWrongAnswer.toString(),
                        style: TextStyle(
                            color: UIColors.textcolor,
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2)),
                      ),
                      Text(
                        "Wrong",
                        style: TextStyle(
                            color: UIColors.textcolor,
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8)),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Column(
                    children: [
                      Text(
                        item.totalNoAnswer.toString(),
                        style: TextStyle(
                            color: UIColors.textcolor,
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2)),
                      ),
                      Text(
                        "Didn't Answer",
                        style: TextStyle(
                            color: UIColors.textcolor,
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8)),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(UIColors.primaryColor),
                      ),
                      onPressed: () {
                        Get.toNamed('/resultPage/${item.examId}');
                      },
                      child: Text(
                        "Result",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(UIColors.primaryColor),
                      ),
                      onPressed: () {
                        Get.toNamed('/answerPage/${item.examId}');
                      },
                      child: Text(
                        "Answer",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(UIColors.primaryColor),
                      ),
                      onPressed: () {
                        Get.toNamed('/meritPage/${item.examId}');
                      },
                      child: Text(
                        "Merit List",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
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
            .collection('exam_result')
            .where('userId', isEqualTo: userId)
            .orderBy('time', descending: true)
            .limit(10)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('exam_result')
            .where('userId', isEqualTo: userId)
            .orderBy('time', descending: true)
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
