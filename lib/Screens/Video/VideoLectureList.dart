/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'dart:io';

import 'package:educationbd/Models/FreeVideoModel.dart';
import 'package:educationbd/Models/LectureVideoModel.dart';
import 'package:educationbd/Models/OfflineVideoModel.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:educationbd/Services/SQFLite/DBQueries.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_VideoLectureList extends StatefulWidget {
  @override
  _QuickTechIT_VideoLectureListState createState() => _QuickTechIT_VideoLectureListState();
}

class _QuickTechIT_VideoLectureListState extends State<QuickTechIT_VideoLectureList> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String id = Get.parameters['topicId'];

  List<FreeVideoModel> freeVideo = [];
  List<LectureVideoModel> lectureVideo = [];

  bool isFree;

  @override
  void initState() {
    if(id == "free"){
      setState(() {
        isFree = true;
      });
      Database().getFreeVideo().then((value) {
        setState(() {
          freeVideo = value;
        });
      });
    } else {
      setState(() {
        isFree = false;
      });
      Database().getLectureVideoByTopic(id).then((value) {
        setState(() {
          lectureVideo = value;
        });
      });
    }
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
          'Videos',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.primaryColor,
          ),
        ),
        backgroundColor: UIColors.backgroundColor,
        elevation: 0.0,
      ),
      backgroundColor: UIColors.backgroundColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: isFree ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: freeVideo.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return freeVideoItemUI(freeVideo[index]);
            }) : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: lectureVideo.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return lectureVideoItemUI(lectureVideo[index]);
            }),
      ),
    );
  }

  freeVideoItemUI(FreeVideoModel item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1),
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed('/videoPlayer/free/${item.id}');
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: Get.width,
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              IconButton(icon: Icon(Icons.download_rounded), onPressed: () async {
                Get.snackbar(item.title, "Start Downloading", backgroundColor: UIColors.primaryColor2, colorText: Colors.white);
                String filePath;
                File offlineVideo = await _downloadFile(item.videoLink, item.id);
                filePath = offlineVideo.path;
                OfflineVideoModel model = new OfflineVideoModel(
                  id: item.id,
                  title: item.title,
                  videoLink: filePath,
                );
                DBQueries().insert(model);
                Get.snackbar(item.title, "Download Complete", backgroundColor: UIColors.primaryColor2, colorText: Colors.white);
                DBQueries().query();
              }),
            ],
          ),
        ),
      ),
    );
  }

  static var httpClient = new HttpClient();
  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  lectureVideoItemUI(LectureVideoModel item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1),
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed('/videoPlayer/lecture/${item.id}');
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: Get.width,
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              IconButton(icon: Icon(Icons.download_rounded), onPressed: () async {
                Get.snackbar(item.title, "Start Downloading", backgroundColor: UIColors.primaryColor2, colorText: Colors.white);
                String filePath;
                File offlineVideo = await _downloadFile(item.videoLink, item.id);
                filePath = offlineVideo.path;
                OfflineVideoModel model = new OfflineVideoModel(
                  id: item.id,
                  title: item.title,
                  videoLink: filePath,
                );
                DBQueries().insert(model);
                Get.snackbar(item.title, "Download Complete", backgroundColor: UIColors.primaryColor2, colorText: Colors.white);
                DBQueries().query();
              }),
            ],
          ),
        ),
      ),
    );
  }

}
