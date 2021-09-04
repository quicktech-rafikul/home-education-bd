/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educationbd/Models/ExamResultModel.dart';
import 'package:educationbd/Models/UserModel.dart';
import 'package:educationbd/Screens/Utils/BottomBar.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_MeritPage extends StatefulWidget {
  @override
  _QuickTechIT_MeritPageState createState() => _QuickTechIT_MeritPageState();
}

class _QuickTechIT_MeritPageState extends State<QuickTechIT_MeritPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String examId = Get.parameters['id'];

  StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> data = [];

  bool _isRequesting = false;
  bool _isFinish = false;

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
    FirebaseFirestore.instance
        .collection('exam_result')
        .where('examId', isEqualTo: examId)
        .orderBy('mark', descending: true)
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
          'Merit',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.textcolor,
          ),
        ),
        backgroundColor: UIColors.bgc1,
        elevation: 0.0,
      ),
      // endDrawer: NavigationDrawer(),
      // bottomNavigationBar: BottomBar(),
      backgroundColor: UIColors.bgc2,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
            requestNextPage();
          }
          return true;
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            children: [
              StreamBuilder<List<DocumentSnapshot>>(
                stream: _streamController.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    return Container(
                      height: 100,
                      child: Center(
                          child: Text(
                        "No Exams Available Today",
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2)),
                      )),
                    );
                  } else if (snapshot.data.length == 0) {
                    return Container(
                      height: 100,
                      child: Center(
                          child: Text(
                        "No Exams Available Today",
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2)),
                      )),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          ExamResultModel model =
                              ExamResultModel.fromDocumentSnapshot(
                                  snapshot.data[index]);

                          return meritItemUI(model, index);
                        });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  meritItemUI(ExamResultModel item, int index) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(item.userId)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        UserModel user = UserModel.fromDocumentSnapshot(snapshot.data);
        return Card(
          color: UIColors.bgc1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(user.profilePic),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 1,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        child: Text(
                          user == null ? "" : user.name,
                          style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.5),
                              fontWeight: FontWeight.bold,
                              color: UIColors.textcolor),
                        ),
                      ),
                      Container(
                        width: Get.width,
                        child: Text(
                          user == null ? "" : user.collegeName,
                          style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.2),
                              color: UIColors.textcolor),
                        ),
                      ),
                      Container(
                        width: Get.width,
                        child: Text(
                          'Mark : ${item.mark}',
                          style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.2),
                              color: UIColors.textcolor),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${index + 1}",
                  style: TextStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(3.5),
                      color: UIColors.textcolor),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void requestNextPage() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;
      if (data.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('exam_result')
            .where('examId', isEqualTo: examId)
            .orderBy('mark', descending: true)
            .limit(20)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('exam_result')
            .where('examId', isEqualTo: examId)
            .orderBy('mark', descending: true)
            .startAfterDocument(data[data.length - 1])
            .limit(20)
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
}
