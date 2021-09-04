/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Models/UserModel.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_Profile extends StatefulWidget {
  @override
  _QuickTechIT_ProfileState createState() => _QuickTechIT_ProfileState();
}

class _QuickTechIT_ProfileState extends State<QuickTechIT_Profile> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserModel user;

  @override
  void initState() {
    Database().getUserData().then((value) {
      setState(() {
        user = value;
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
          'Profile',
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(3),
            color: UIColors.primaryColor,
          ),
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.all(15),
            icon: Icon(
              Icons.edit_outlined,
              color: UIColors.primaryColor2,
            ),
            onPressed: () {
              Get.toNamed('/profile/edit');
            },
          ),
        ],
        backgroundColor: UIColors.backgroundColor,
        elevation: 0.0,
      ),
      backgroundColor: UIColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200.0),
                          child: user == null
                              ? Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.white,
                                )
                              : Image.network(user.profilePic),
                        ),
                      ),
                      Container(
                        child: Text(
                          user == null ? "" : user.name,
                          style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(2.2),
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
