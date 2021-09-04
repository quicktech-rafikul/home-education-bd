/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Models/TopicModel.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_FlashCardTopicList extends StatefulWidget {
  @override
  _QuickTechIT_FlashCardTopicListState createState() =>
      _QuickTechIT_FlashCardTopicListState();
}

class _QuickTechIT_FlashCardTopicListState
    extends State<QuickTechIT_FlashCardTopicList> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String subjectId = Get.parameters["subjectId"];

  List<TopicModel> topics = [];

  @override
  void initState() {
    Database().getTopicsBySubject(subjectId).then((value) {
      setState(() {
        topics = value;
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
            color: UIColors.textcolor,
            size: 20,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Topic List',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.textcolor,
          ),
        ),
        backgroundColor: UIColors.bgc2,
        elevation: 0.0,
      ),
      backgroundColor: UIColors.bgc1,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: topics.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Column(
                children: [
                  Container(
                    width: Get.width,
                    child: TextButton(
                        onPressed: () {
                          Get.toNamed('/flashCards/${topics[index].id}');
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                UIColors.primaryColor2),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.fromLTRB(0, 20, 0, 20))),
                        child: Text(
                          topics[index].title,
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
