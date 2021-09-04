/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Models/LectureNoteModel.dart';
import 'package:educationbd/Screens/Utils/BottomBar.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_LectureNoticeList extends StatefulWidget {
  @override
  _QuickTechIT_LectureNoticeListState createState() => _QuickTechIT_LectureNoticeListState();
}

class _QuickTechIT_LectureNoticeListState extends State<QuickTechIT_LectureNoticeList> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String topicId = Get.parameters['topicId'];

  List<LectureNoteModel> notices = [];

  @override
  void initState() {
    Database().getLectureNoteByTopic(topicId).then((value) {
      setState(() {
        notices = value;
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
          'Notices',
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: notices.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Column(
                children: [
                  Card(
                      child: InkWell(
                    onTap: () {
                      Get.toNamed('/noticeView/${notices[index].id}');
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        width: Get.width,
                        child: Column(
                          children: [
                            Container(
                                width: Get.width,
                                child: Text(
                                  notices[index].title,
                                  style: TextStyle(
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2)),
                                  textAlign: TextAlign.justify,
                                )),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  DateFormat.yMMMd().format(notices[index].time.toDate()),

                                  style: TextStyle(
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(1.5)),
                                ))
                          ],
                        )),
                  ))
                ],
              );
            }),
      ),
    );
  }
}
