/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Models/AnswerModel.dart';
import 'package:educationbd/Models/ExamResultModel.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class QuickTechIT_AnswerPage extends StatefulWidget {
  @override
  _QuickTechIT_AnswerPageState createState() => _QuickTechIT_AnswerPageState();
}

class _QuickTechIT_AnswerPageState extends State<QuickTechIT_AnswerPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String examId = Get.parameters['id'];

  ExamResultModel result;
  List<AnswerModel> correctAnswers = [];

  String userId = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    Database().getCentralTestResultById("$examId+-+$userId").then((value) {
      setState(() {
        result = value;
      });

      if (result != null) {
        Database().getCentralTestResultAnswers(result.id).then((value) {
          setState(() {
            correctAnswers = value;
          });
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          'Answer',
          style: TextStyle(
              fontSize: ResponsiveFlutter.of(context).fontSize(3),
              color: UIColors.textcolor),
        ),
        backgroundColor: UIColors.bgc1,
        elevation: 0.0,
      ),
      backgroundColor: UIColors.bgc2,
      body: result == null
          ? Center(child: Text("Please attend the exam"))
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                      child: result == null
                          ? Center(child: CircularProgressIndicator())
                          : SfPdfViewer.network(result.questionLink)),
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(2),
                                2: FlexColumnWidth(3),
                              },
                              border: TableBorder.all(color: Colors.grey),
                              children: [
                                TableRow(children: [
                                  Center(
                                      child: Text(
                                    'No.',
                                    style: TextStyle(
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2),
                                      color: UIColors.textcolor,
                                    ),
                                  )),
                                  Center(
                                      child: Text(
                                    'Answer',
                                    style: TextStyle(
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2),
                                      color: UIColors.textcolor,
                                    ),
                                  )),
                                  Center(
                                      child: Text(
                                    'Correct Answer',
                                    style: TextStyle(
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2),
                                      color: UIColors.textcolor,
                                    ),
                                  )),
                                ]),
                              ]),
                        ),
                        Container(
                          color: UIColors.bgc2,
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(2),
                                2: FlexColumnWidth(3),
                              },
                              border: TableBorder.all(color: Colors.grey),
                              children: [
                                for (int i = 0; i < correctAnswers.length; i++)
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                          child: Text(
                                        (i + 1).toString(),
                                        style: TextStyle(
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(2),
                                          color: UIColors.textcolor,
                                        ),
                                      )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                          child: Text(
                                        correctAnswers[i].answer,
                                        style: TextStyle(
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(2),
                                          color: UIColors.textcolor,
                                        ),
                                      )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                          child: Text(
                                        correctAnswers[i].correctAnswer,
                                        style: TextStyle(
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(2),
                                          color: UIColors.textcolor,
                                        ),
                                      )),
                                    ),
                                  ])
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
