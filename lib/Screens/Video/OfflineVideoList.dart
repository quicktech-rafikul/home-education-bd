/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/


import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:educationbd/Models/OfflineVideoModel.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/SQFLite/DBQueries.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:video_player/video_player.dart';

class QuickTechIT_OfflineVideoList extends StatefulWidget {
  @override
  _QuickTechIT_OfflineVideoListState createState() => _QuickTechIT_OfflineVideoListState();
}

class _QuickTechIT_OfflineVideoListState extends State<QuickTechIT_OfflineVideoList> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  List<OfflineVideoModel> videoList = [];

  @override
  void initState() {
    DBQueries().query().then((value) {
      if(mounted){
        setState(() {
          videoList = value;
        });
      }
    });

    super.initState();
  }

  Future<void> initializePlayer(String videoLink) async {
    _videoPlayerController = VideoPlayerController.file(File(videoLink));
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    if(mounted){setState(() {});}
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
          'Offline Videos',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.primaryColor,
          ),
        ),
        backgroundColor: UIColors.backgroundColor,
        elevation: 0.0,
      ),
      backgroundColor: UIColors.backgroundColor,
      body: videoList.length == 0 ? Center(child: Text("You don't have any offline videos")) : SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          children: [
            Container(
              height: _chewieController != null ? Get.height/3 : 0,
              child: _chewieController != null &&
                  _chewieController
                      .videoPlayerController.value.initialized
                  ? Chewie(
                controller: _chewieController,
              )
                  : Container()
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: videoList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return videoItemUI(videoList[index]);
                }),
          ],
        ),
      ),
    );
  }

  videoItemUI(OfflineVideoModel item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1),
      ),
      child: InkWell(
        onTap: () {
          initializePlayer(item.videoLink);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
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
      ),
    );
  }
}
