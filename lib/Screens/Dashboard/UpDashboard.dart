import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationbd/Models/CentralTestExamModel.dart';
import 'package:educationbd/Models/CourseModel.dart';
import 'package:educationbd/Models/SliderModel.dart';
import 'package:educationbd/Models/UserModel.dart';
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
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types
class QuickTechIT_UpDashboard extends StatefulWidget {
  @override
  _QuickTechIT_UpDashboardState createState() =>
      _QuickTechIT_UpDashboardState();
}

// ignore: camel_case_types
class _QuickTechIT_UpDashboardState extends State<QuickTechIT_UpDashboard> {
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
  UserModel user;

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
    Database().getUserData().then((value) {
      setState(() {
        user = value;
      });
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
      backgroundColor: UIColors.bgc1,
      bottomNavigationBar: BottomBar(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: UIColors.bgc1,
              child: Stack(
                children: [
                  SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                color: UIColors.bgc2,
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed('/performance');
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(200.0),
                                          child: user == null
                                              ? Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color: Colors.white,
                                                )
                                              : Image.network(user.profilePic),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              greetingMessage(),
                                              style: TextStyle(
                                                  color: UIColors.textcolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              localData.read('userName'),
                                              style: TextStyle(
                                                  color: UIColors.textcolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        courseDialog();
                                      },
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              'Course',
                                              style: TextStyle(
                                                color: UIColors.textcolor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(
                                              Icons.subject,
                                              color: UIColors.textcolor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Runnig Exams",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: UIColors.textcolor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: Column(
                                  children: [
                                    StreamBuilder<List<DocumentSnapshot>>(
                                      stream: _streamController.stream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<DocumentSnapshot>>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return new Text(
                                              'Error: ${snapshot.error}');
                                        } else if (snapshot.data == null) {
                                          return Container(
                                            height: 100,
                                            child: Center(
                                              child: Text(
                                                "No Exams Available Today",
                                                style: TextStyle(
                                                    fontSize:
                                                        ResponsiveFlutter.of(
                                                                context)
                                                            .fontSize(2)),
                                              ),
                                            ),
                                          );
                                        } else if (snapshot.data.length == 0) {
                                          return Container(
                                            height: 100,
                                            child: Center(
                                                child: Text(
                                              "No Exams Available Today",
                                              style: TextStyle(
                                                  fontSize:
                                                      ResponsiveFlutter.of(
                                                              context)
                                                          .fontSize(2)),
                                            )),
                                          );
                                        } else {
                                          return CarouselSlider(
                                            options: CarouselOptions(
                                              height: 160.0,
                                              enlargeCenterPage: true,
                                              autoPlay: false,
                                              aspectRatio: 16 / 9,
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enableInfiniteScroll: true,
                                              autoPlayAnimationDuration:
                                                  Duration(milliseconds: 800),
                                              viewportFraction: 0.8,
                                            ),
                                            items: snapshot.data.map<Widget>(
                                                (DocumentSnapshot document) {
                                              CentralTestExamModel model =
                                                  CentralTestExamModel
                                                      .fromDocumentSnapshot(
                                                          document);
                                              return examItemUI(model);
                                            }).toList(),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Exam Preparation',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: UIColors.textcolor,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ExamPreparation(),
                              SizedBox(
                                height: 10,
                              ),
                              BuyPackage(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                  'End Date: ${item.endDate}',
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
                        'Mark: ${item.totalMark}',
                        style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2),
                          color: UIColors.textcolor,
                        ),
                      ),
                      Text(
                        'Eaxm Duration: ${item.duration}',
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
          decoration: BoxDecoration(),
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

class BuyPackage extends StatelessWidget {
  const BuyPackage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: UIColors.bgc2,
        borderRadius: BorderRadius.circular(0),
      ),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "Purchases to unlock all feature.",
              style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(2),
                  color: Colors.white),
            ),
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(UIColors.primaryColor),
                padding:
                    MaterialStateProperty.all(EdgeInsets.fromLTRB(5, 5, 5, 5))),
            onPressed: () {
              Get.toNamed('/packages');
            },
            child: Text(
              "Buy",
              style: TextStyle(color: UIColors.textcolor),
            ),
          ),
        ],
      ),
    );
  }
}

class ExamPreparation extends StatelessWidget {
  const ExamPreparation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: UIColors.bgc2,
      ),
      height: 180,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed('/centralTest');
                  },
                  child: Container(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/quiz.png',
                          width: 60,
                          height: 50,
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Exams',
                          style: TextStyle(
                            fontSize: 14,
                            color: UIColors.textcolor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed('/flashCard/subjects');
                  },
                  child: Container(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/all.png',
                          width: 60,
                          height: 50,
                        ),
                        SizedBox(height: 3),
                        Text(
                          'All Subject',
                          style: TextStyle(
                            fontSize: 14,
                            color: UIColors.textcolor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed('/mcq/subject');
                  },
                  child: Container(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/qbank.png',
                          width: 60,
                          height: 50,
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Question Bank',
                          style: TextStyle(
                            fontSize: 14,
                            color: UIColors.textcolor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed('/mcq/subject');
                  },
                  child: Container(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/prep.png',
                          width: 60,
                          height: 50,
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Preparation',
                          style: TextStyle(
                            fontSize: 14,
                            color: UIColors.textcolor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed('/mcq/subject');
                  },
                  child: Container(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/lg.png',
                          width: 60,
                          height: 50,
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Quiz',
                          style: TextStyle(
                            fontSize: 14,
                            color: UIColors.textcolor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed('/notice/subjects');
                  },
                  child: Container(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/subjective.png',
                          width: 60,
                          height: 50,
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Lectures',
                          style: TextStyle(
                            fontSize: 14,
                            color: UIColors.textcolor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
