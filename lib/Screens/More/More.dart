/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:app_review/app_review.dart';
import 'package:educationbd/Controller/AuthController.dart';
import 'package:educationbd/Models/CourseModel.dart';
import 'package:educationbd/Screens/Code/CheckLogin.dart';
import 'package:educationbd/Screens/Utils/BottomBar.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickTechIT_More extends StatefulWidget {
  @override
  _QuickTechIT_MoreState createState() => _QuickTechIT_MoreState();
}

class _QuickTechIT_MoreState extends State<QuickTechIT_More> {
  final localData = GetStorage();

  List<CourseModel> courses = [];

  String appID = "";
  String output = "";
  String appVersion = "";

  @override
  void initState() {
    AppReview.getPackageInfo().then((onValue) {
      setState(() {
        appID = onValue.packageName;
        appVersion = onValue.version;
      });
    });

    Database().getCourses().then((value) {
      setState(() {
        courses = value;
      });
    });
    super.initState();
  }

  _launchURL() async {
    const url = 'https://quicktech-ltd.com/';
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(),
      backgroundColor: UIColors.bgc1,
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                  width: Get.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FractionallySizedBox(
                                        widthFactor: .8,
                                        child: Container(
                                          height: 120,
                                          child: Image.asset(
                                              'assets/images/icon.png'),
                                        ),
                                      ),
                                      Text(
                                        localData.read('userName'),
                                        style: TextStyle(
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(3.5),
                                            fontWeight: FontWeight.bold,
                                            color: UIColors.textcolor),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        localData.read('userMobile'),
                                        style: TextStyle(
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(2.5),
                                            color: UIColors.primaryColor),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              Get.toNamed('/generalQuestions');
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(.5),
                                                    blurRadius: 4,
                                                    offset: Offset(4,
                                                        4), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.question_answer),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text("General Questions")
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              AppReview.storeListing
                                                  .then((onValue) {
                                                setState(() {
                                                  output = onValue;
                                                });
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(.5),
                                                    blurRadius: 4,
                                                    offset: Offset(4,
                                                        4), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.rate_review),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text("App Review")
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: Get.width / 2.5,
                                        child: InkWell(
                                          onTap: () {
                                            AuthController().signOut();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(.5),
                                                  blurRadius: 4,
                                                  offset: Offset(4,
                                                      4), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.logout),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text("Log Out")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            Container(
              width: Get.width,
              padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: Column(
                children: [
                  Text(
                    'App Version : $appVersion',
                    style: TextStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(2),
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Design & Developed By',
                        style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _launchURL();
                        },
                        child: Text(
                          'QuickTech IT',
                          style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            color: UIColors.textcolor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
}
