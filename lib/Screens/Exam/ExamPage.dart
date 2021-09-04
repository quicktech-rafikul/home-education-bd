/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Models/AnswerModel.dart';
import 'package:educationbd/Models/CentralTestExamModel.dart';
import 'package:educationbd/Models/ExamResultModel.dart';
import 'package:educationbd/Models/MCQPreparationModel.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class QuickTechIT_ExamPage extends StatefulWidget {
  @override
  _QuickTechIT_ExamPageState createState() => _QuickTechIT_ExamPageState();
}

class _QuickTechIT_ExamPageState extends State<QuickTechIT_ExamPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String type = Get.parameters['type'];
  String id = Get.parameters['id'];

  CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 30;

  String document;

  List<String> answers = [];
  List<String> options = ["A", "B", "C", "D"];

  CentralTestExamModel centralTest;
  MCQPreparationModel mcqPreparation;

  List<String> correctAnswers = [];

  @override
  void initState() {
    if (type == "central") {
      Database().getCentralTestExamById(id).then((value) {
        setState(() {
          centralTest = value;
          endTime = DateTime.now().millisecondsSinceEpoch +
              1000 * 60 * centralTest.duration;
          for (int i = 0; i < centralTest.totalQuestion; i++) {
            answers.insert(i, "");
          }
        });
        setState(() {
          document = centralTest.questionLink;
        });

        Database().getCentralTestAnswers(centralTest.id).then((value) {
          setState(() {
            correctAnswers = value;
          });
        });
      });
    } else if (type == "mcq") {
      Database().getMCQPreparationsById(id).then((value) {
        setState(() {
          mcqPreparation = value;
          endTime = DateTime.now().millisecondsSinceEpoch +
              1000 * 60 * mcqPreparation.duration;
          for (int i = 0; i < mcqPreparation.totalQuestion; i++) {
            answers.insert(i, "");
          }
        });
        setState(() {
          document = mcqPreparation.questionLink;
        });

        Database().getMCQPreparationAnswers(mcqPreparation.id).then((value) {
          setState(() {
            correctAnswers = value;
          });
        });
      });
    }

    super.initState();
  }

  void onEnd() {
    if (type == 'central') {
      submitAnswerOfCentralTest();
    } else if (type == 'mcq') {
      submitAnswerOfMCQPreparation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text('Are you sure you want to quit?'),
                  actions: <Widget>[
                    ElevatedButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(false)),
                    ElevatedButton(
                        child: Text('Yes'),
                        onPressed: () {
                          onEnd();
                          Navigator.of(context).pop(true);
                        }),
                  ])),
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: CountdownTimer(
            controller: controller,
            onEnd: onEnd,
            endTime: endTime,
            widgetBuilder: (_, CurrentRemainingTime time) {
              int hour, min, sec;
              if (time != null) {
                if (time.hours != null) {
                  hour = time.hours;
                } else {
                  hour = 0;
                }
                if (time.min != null) {
                  min = time.min;
                } else {
                  min = 0;
                }
                if (time.sec != null) {
                  sec = time.sec;
                } else {
                  sec = 0;
                }
              }
              if (time == null) {
                return Text('Time over');
              }
              return Text('$hour : $min : $sec');
            },
          ),
          backgroundColor: UIColors.bgc2,
          elevation: 0.0,
        ),
        backgroundColor: UIColors.bgc1,
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: document == null
                    ? Center(child: CircularProgressIndicator())
                    : SfPdfViewer.network(document),
              ),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: type == 'central'
                            ? centralTest == null
                                ? 0
                                : centralTest.totalQuestion
                            : mcqPreparation == null
                                ? 0
                                : mcqPreparation.totalQuestion,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Row(
                            children: [
                              Text("${index + 1}."),
                              SizedBox(
                                width: 10,
                              ),
                              SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: options.map<Widget>((option) {
                                      return Row(
                                        children: [
                                          Radio(
                                            value: option,
                                            activeColor: UIColors.textcolor,
                                            groupValue: answers[index],
                                            onChanged: (val) => setState(() {
                                              answers[index] = val;
                                            }),
                                          ),
                                          Text("$option"),
                                          SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      );
                                    }).toList(),
                                  )),
                            ],
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        onEnd();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(UIColors.primaryColor),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.fromLTRB(30, 10, 30, 10))),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: UIColors.textcolor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  submitAnswerOfCentralTest() async {
    String examId = centralTest.id;
    String examName = centralTest.examName;
    String userId = FirebaseAuth.instance.currentUser.uid;
    String questionLink = centralTest.questionLink;
    int totalQuestion = centralTest.totalQuestion;
    int totalAnswer = 0;
    int totalNoAnswer = 0;
    int totalCorrectAnswer = 0;
    int totalWrongAnswer = 0;
    double mark = 0.0;
    double negativeMark = 0.0;
    List<AnswerModel> finalAnswers = [];

    for (int i = 0; i < answers.length; i++) {
      finalAnswers.add(new AnswerModel(
          answer: answers[i], correctAnswer: correctAnswers[i]));
      if (answers[i] == "") {
        totalNoAnswer++;
      } else {
        totalAnswer++;
        if (correctAnswers[i] == answers[i]) {
          totalCorrectAnswer++;
          mark += 1.0;
        } else {
          totalWrongAnswer++;
          if (centralTest.isNegative) {
            negativeMark += centralTest.negativeMark;
            mark -= centralTest.negativeMark;
          }
        }
      }
    }

    ExamResultModel model = new ExamResultModel(
        examId: examId,
        examName: examName,
        userId: userId,
        questionLink: questionLink,
        totalQuestion: totalQuestion,
        totalAnswer: totalAnswer,
        totalNoAnswer: totalNoAnswer,
        totalCorrectAnswer: totalCorrectAnswer,
        totalWrongAnswer: totalWrongAnswer,
        mark: mark,
        negativeMark: negativeMark);

    await Database().createExamResult(model, finalAnswers).then((value) {
      Get.back();
    });
  }

  submitAnswerOfMCQPreparation() async {
    String examId = mcqPreparation.id;
    String examName = mcqPreparation.examName;
    String userId = FirebaseAuth.instance.currentUser.uid;
    String questionLink = mcqPreparation.questionLink;
    int totalQuestion = mcqPreparation.totalQuestion;
    int totalAnswer = 0;
    int totalNoAnswer = 0;
    int totalCorrectAnswer = 0;
    int totalWrongAnswer = 0;
    double mark = 0.0;
    double negativeMark = 0.0;
    List<AnswerModel> finalAnswers = [];

    for (int i = 0; i < answers.length; i++) {
      finalAnswers.add(new AnswerModel(
          answer: answers[i], correctAnswer: correctAnswers[i]));
      if (answers[i] == "") {
        totalNoAnswer++;
      } else {
        totalAnswer++;
        if (correctAnswers[i] == answers[i]) {
          totalCorrectAnswer++;
          mark += 1.0;
        } else {
          totalWrongAnswer++;
          if (mcqPreparation.isNegative) {
            negativeMark += mcqPreparation.negativeMark;
            mark -= mcqPreparation.negativeMark;
          }
        }
      }
    }

    ExamResultModel model = new ExamResultModel(
        examId: examId,
        examName: examName,
        userId: userId,
        questionLink: questionLink,
        totalQuestion: totalQuestion,
        totalAnswer: totalAnswer,
        totalNoAnswer: totalNoAnswer,
        totalCorrectAnswer: totalCorrectAnswer,
        totalWrongAnswer: totalWrongAnswer,
        mark: mark,
        negativeMark: negativeMark);

    await Database().createExamResult(model, finalAnswers).then((value) {
      Get.back();
    });
  }
}
