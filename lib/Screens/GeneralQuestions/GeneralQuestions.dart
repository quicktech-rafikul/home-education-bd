/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Models/GeneralQuestionModel.dart';
import 'package:educationbd/Screens/Utils/BottomBar.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_GeneralQuestions extends StatefulWidget {
  @override
  _QuickTechIT_GeneralQuestionsState createState() =>
      _QuickTechIT_GeneralQuestionsState();
}

class _QuickTechIT_GeneralQuestionsState
    extends State<QuickTechIT_GeneralQuestions> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<GeneralQuestionModel> ques = [];

  @override
  void initState() {
    Database().getGeneralQuestions().then((value) {
      setState(() {
        ques = value;
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
          'General Questions',
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: ques.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return ruleItemUI(ques[index]);
                }),
          ],
        ),
      ),
    );
  }

  ruleItemUI(GeneralQuestionModel item) {
    return Container(
      padding: EdgeInsets.all(8),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Get.width,
            child: Text(
              item.question,
              style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                  color: UIColors.textcolor,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: Get.width,
            child: Text(
              item.answer,
              style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                  color: UIColors.textcolor),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
