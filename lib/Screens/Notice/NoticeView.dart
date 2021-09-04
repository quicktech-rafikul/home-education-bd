/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Models/NoticeModel.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class QuickTechIT_NoticeView extends StatefulWidget {
  @override
  _QuickTechIT_NoticeViewState createState() => _QuickTechIT_NoticeViewState();
}

class _QuickTechIT_NoticeViewState extends State<QuickTechIT_NoticeView> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String noticeId = Get.parameters['id'];

  NoticeModel notice;

  @override
  void initState() {
    Database().getNoticeById(noticeId).then((value) {
      setState(() {
        notice = value;
      });
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
            color: UIColors.primaryColor2,
            size: 20,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          notice == null ? 'Notice Title' : notice.title,
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.primaryColor,
          ),
        ),
        backgroundColor: UIColors.backgroundColor,
        elevation: 0.0,
      ),
      backgroundColor: UIColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: notice == null
              ? Center(child: CircularProgressIndicator())
              : SfPdfViewer.network(notice.pdfLink)
        ),
      ),
    );
  }
}
