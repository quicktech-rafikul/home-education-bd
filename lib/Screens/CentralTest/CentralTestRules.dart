/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Models/CentralTestRulesModel.dart';
import 'package:educationbd/Screens/Utils/BottomBar.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_CentralTestRules extends StatefulWidget {
  @override
  _QuickTechIT_CentralTestRulesState createState() =>
      _QuickTechIT_CentralTestRulesState();
}

class _QuickTechIT_CentralTestRulesState
    extends State<QuickTechIT_CentralTestRules> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<CentralTestRulesModel> rules = [];

  @override
  void initState() {
    Database().getCentralTestRules().then((value) {
      setState(() {
        rules = value;
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
          'Central Test Rules',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.textcolor,
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
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: rules.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return ruleItemUI(rules[index]);
                }),
          ],
        ),
      ),
    );
  }

  ruleItemUI(CentralTestRulesModel item) {
    return Container(
      padding: EdgeInsets.all(8),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Get.width,
            child: Text(
              item.title,
              style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                  fontWeight: FontWeight.bold,
                  color: UIColors.textcolor),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: Get.width,
            child: Text(
              item.description,
              style: TextStyle(
                fontSize: ResponsiveFlutter.of(context).fontSize(2.2),
                color: UIColors.textcolor,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
