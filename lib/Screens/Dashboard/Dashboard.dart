/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationbd/Models/CentralTestExamModel.dart';
import 'package:educationbd/Models/CourseModel.dart';
import 'package:educationbd/Models/SliderModel.dart';
import 'package:educationbd/Screens/Code/CheckLogin.dart';
import 'package:educationbd/Screens/Utils/BottomBar.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_Dashboard extends StatefulWidget {
  @override
  _QuickTechIT_DashboardState createState() => _QuickTechIT_DashboardState();
}

class _QuickTechIT_DashboardState extends State<QuickTechIT_Dashboard> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<SliderModel> sliders = [];

  final localData = GetStorage();

  List<CourseModel> courses = [];

  List<String> options = [
    "Central Test",
    "Video Lecture",
    "Preparation",
    "Flash Card",
    "Lecture Notice",
    "Offline Video"
  ];
  List<String> optionIcons = [
    "central_test",
    "video_lecture",
    "mcq_preparation",
    "flash_card",
    "lecture_notice",
    "offline_video"
  ];

  StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> data = [];

  bool _isRequesting = false;
  bool _isFinish = false;

  String courseName;

  static final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  String startDate = dateFormatter.format(DateTime.now());

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
    Database().getSliders().then((value) {
      setState(() {
        sliders = value;
      });
    });

    Database().getCourses().then((value) {
      setState(() {
        courses = value;
      });
      for (int i = 0; i < value.length; i++) {
        if (value[i].id == localData.read('userCourse')) {
          courseName = value[i].title;
        }
      }
    });

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Container(
                      width: Get.width,
                      decoration: new BoxDecoration(
                        color: UIColors.primaryColor.withOpacity(.6),
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(300, 50.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          FractionallySizedBox(
                              widthFactor: .8,
                              child: Image.asset('assets/images/logo.png')),
                          Text(
                            greetingMessage(),
                            style: TextStyle(
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(3),
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            localData.read('userName'),
                            style: TextStyle(
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(3.5),
                                fontWeight: FontWeight.bold,
                                color: UIColors.primaryColor2),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            courseName == null ? "" : courseName,
                            style: TextStyle(
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(2.5),
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FractionallySizedBox(
                            widthFactor: .8,
                            child: Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        courseDialog();
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/icons/course.png',
                                              width: 40,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Course",
                                              style: TextStyle(
                                                  fontSize:
                                                      ResponsiveFlutter.of(
                                                              context)
                                                          .fontSize(1.7)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Get.toNamed('/profile');
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/icons/profile.png',
                                              width: 40,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Profile",
                                              style: TextStyle(
                                                  fontSize:
                                                      ResponsiveFlutter.of(
                                                              context)
                                                          .fontSize(1.7)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Get.toNamed('/performance');
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/icons/performence.png',
                                              width: 40,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Performance",
                                              style: TextStyle(
                                                  fontSize:
                                                      ResponsiveFlutter.of(
                                                              context)
                                                          .fontSize(1.7)),
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
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      )),
                ],
              ),
              FractionalTranslation(
                  translation: Offset(0.0, -0.12),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            childAspectRatio: 1.2,
                            padding: const EdgeInsets.all(8.0),
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                            children: options.map((String btnText) {
                              return InkWell(
                                onTap: () {
                                  optionsNextPage(btnText);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(.5),
                                        blurRadius: 1,
                                        offset: Offset(
                                            1, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/${optionIcons[options.indexOf(btnText)]}.png',
                                        width: 40,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(btnText)
                                    ],
                                  ),
                                ),
                              );
                            }).toList()),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: Get.width,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: UIColors.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Buy packages to get full features",
                                  style: TextStyle(
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2),
                                      color: Colors.white),
                                ),
                              ),
                              TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              UIColors.primaryColor2),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.fromLTRB(5, 5, 5, 5))),
                                  onPressed: () {
                                    Get.toNamed('/packages');
                                  },
                                  child: Text(
                                    "Buy",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: Get.width,
                          child: Text(
                            "Today's Exam",
                            style: TextStyle(
                                fontSize: ResponsiveFlutter.of(context)
                                    .fontSize(2.5)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 5,
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
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2)),
                                )),
                              );
                            } else if (snapshot.data.length == 0) {
                              return Container(
                                height: 100,
                                child: Center(
                                    child: Text(
                                  "No Exams Available Today",
                                  style: TextStyle(
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2)),
                                )),
                              );
                            } else {
                              return ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: snapshot.data
                                    .map<Widget>((DocumentSnapshot document) {
                                  CentralTestExamModel model =
                                      CentralTestExamModel.fromDocumentSnapshot(
                                          document);
                                  return examItemUI(model);
                                }).toList(),
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (sliders != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 2.5,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                viewportFraction: 2,
                                reverse: true,
                                autoPlay: true,
                              ),
                              items: sliders.map((SliderModel item) {
                                return Container(
                                    width: Get.width,
                                    child: Image.network(
                                      item.imageUrl,
                                      fit: BoxFit.fitWidth,
                                    ));
                              }).toList(),
                            ),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  examItemUI(CentralTestExamModel item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1),
      ),
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
                    fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
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
                  ),
                ),
                Text(
                  'Duration: ${item.duration}',
                  style: TextStyle(
                    fontSize: ResponsiveFlutter.of(context).fontSize(2),
                  ),
                ),
              ],
            ),
            Center(
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

  void optionsNextPage(String text) {
    if (text == options[0]) {
      Get.toNamed('/centralTest');
    } else if (text == options[1]) {
      Get.toNamed('/videoLectureSubject');
    } else if (text == options[2]) {
      Get.toNamed('/mcq/subject');
    } else if (text == options[3]) {
      Get.toNamed('/flashCard/subjects');
    } else if (text == options[4]) {
      Get.toNamed('/notice/subjects');
    } else if (text == options[5]) {
      Get.toNamed('/offlineVideoList');
    }
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

  courseDialog() {
    return Get.defaultDialog(
        title: "Select Course",
        content: Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: courses.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return RadioListTile(
                  value: courses[index].id,
                  groupValue: localData.read('userCourse'),
                  onChanged: (val) {
                    Database()
                        .updateUserCourse(courses[index].id)
                        .then((value) {
                      CheckLogin().checkData();
                    });
                  },
                  title: Text(courses[index].title),
                );
              }),
        ));
  }

  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if ((timeNow > 4) && (timeNow <= 12)) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }
}
