/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Models/FreeVideoModel.dart';
import 'package:educationbd/Models/LectureVideoModel.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:chewie/chewie.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:video_player/video_player.dart';

class QuickTechIT_VideoPlayerScreen extends StatefulWidget {
  @override
  _QuickTechIT_VideoPlayerScreenState createState() => _QuickTechIT_VideoPlayerScreenState();
}

class _QuickTechIT_VideoPlayerScreenState extends State<QuickTechIT_VideoPlayerScreen> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  String videoType = Get.parameters['type'];
  String videoId = Get.parameters['id'];

  FreeVideoModel freeVideo;
  LectureVideoModel lectureVideo;

  @override
  void initState() {
    super.initState();
    if(videoType == 'free') {
      Database().getFreeVideoById(videoId).then((value) {
        setState(() {
          freeVideo = value;
        });
        initializePlayer(freeVideo.videoLink);
      });
    } else {
      Database().getLectureVideoById(videoId).then((value) {
        setState(() {
          lectureVideo = value;
        });
        initializePlayer(lectureVideo.videoLink);
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer(String videoLink) async {
    _videoPlayerController = VideoPlayerController.network(videoLink);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
          'Title',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.primaryColor,
          ),
        ),
        backgroundColor: UIColors.backgroundColor,
        elevation: 0.0,
      ),
      backgroundColor: UIColors.backgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: _chewieController != null &&
                  _chewieController
                      .videoPlayerController.value.initialized
                  ? Chewie(
                controller: _chewieController,
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}