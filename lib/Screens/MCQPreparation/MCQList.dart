/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Models/MCQPreparationModel.dart';
import 'package:educationbd/Models/TopicModel.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_MCQList extends StatefulWidget {
  @override
  _QuickTechIT_MCQListState createState() => _QuickTechIT_MCQListState();
}

class _QuickTechIT_MCQListState extends State<QuickTechIT_MCQList> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String topicId = Get.parameters['topicId'];

  List<MCQPreparationModel> exams = [];

  @override
  void initState() {
    Database().getMCQPreparationsByTopic(topicId).then((value) {
      setState(() {
        exams = value;
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
          'Exam List',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.primaryColor,
          ),
        ),
        backgroundColor: UIColors.backgroundColor,
        elevation: 0.0,
      ),
      backgroundColor: UIColors.backgroundColor,
      body: exams.length == 0 ? Center(child: Text("No Exams Available"),) : SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: exams.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),
                ),
                child: InkWell(
                  onTap: () {
                    Get.toNamed('/examPage/mcq/${exams[index].id}');
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    width: Get.width,
                    child: Text(
                      exams[index].examName,
                      style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                          color: Colors.black),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
