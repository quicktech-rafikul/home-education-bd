/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Models/FlashCardModel.dart';
import 'package:educationbd/Screens/Utils/BottomBar.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_FlashCardList extends StatefulWidget {
  @override
  _QuickTechIT_FlashCardListState createState() =>
      _QuickTechIT_FlashCardListState();
}

class _QuickTechIT_FlashCardListState extends State<QuickTechIT_FlashCardList> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String topicId = Get.parameters['topicId'];

  List<FlashCardModel> cards = [];

  @override
  void initState() {
    Database().getFlashCardsByTopic(topicId).then((value) {
      setState(() {
        cards = value;
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
          'Cards',
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
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cards.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Card(
                  child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                        width: Get.width,
                        child: InteractiveViewer(
                          child: Image.network(
                            cards[index].imageLink,
                            fit: BoxFit.fitWidth,
                          ),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: Get.width,
                      child: Text(
                        cards[index].title,
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2)),
                      ),
                    )
                  ],
                ),
              ));
            }),
      ),
    );
  }
}
