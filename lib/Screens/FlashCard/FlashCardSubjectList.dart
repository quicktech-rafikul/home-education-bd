/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Models/SubjectModel.dart';
import 'package:educationbd/Screens/Utils/BottomBar.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_FlashCardSubjectList extends StatefulWidget {
  @override
  _QuickTechIT_FlashCardSubjectListState createState() =>
      _QuickTechIT_FlashCardSubjectListState();
}

class _QuickTechIT_FlashCardSubjectListState
    extends State<QuickTechIT_FlashCardSubjectList> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<SubjectModel> subjects = [];

  @override
  void initState() {
    Database().getSubjects().then((value) {
      setState(() {
        subjects = value;
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
          'All Subject',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.textcolor,
          ),
        ),
        backgroundColor: UIColors.bgc2,
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: subjects.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Column(
                children: [
                  Container(
                    width: Get.width,
                    child: TextButton(
                        onPressed: () async {
                          if (subjects[index].isPremium) {
                            if (await Database()
                                .checkPremiumPackage(subjects[index].id)) {
                              Get.toNamed(
                                  '/flashCard/topics/${subjects[index].id}');
                            } else {
                              Get.defaultDialog(
                                  title: "Premium Subject",
                                  content: Text("Bye package to get the list"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("Ok"))
                                  ]);
                            }
                          } else {
                            Get.toNamed(
                                '/flashCard/topics/${subjects[index].id}');
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                UIColors.primaryColor2),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.fromLTRB(0, 20, 0, 20))),
                        child: Text(
                          subjects[index].title,
                          style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.5),
                              color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              );
            }),
      ),
    );
  }
}
