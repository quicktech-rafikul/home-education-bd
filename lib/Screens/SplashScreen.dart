/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Screens/Code/CheckLogin.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuickTechIT_SplashScreen extends StatefulWidget {
  @override
  _QuickTechIT_SplashScreenState createState() =>
      _QuickTechIT_SplashScreenState();
}

class _QuickTechIT_SplashScreenState extends State<QuickTechIT_SplashScreen> {
  @override
  void initState() {
    super.initState();

    new Future.delayed(const Duration(seconds: 2), () async {
      await CheckLogin().checkData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColors.bgc1,
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: 140,
                  width: 140,
                  child: Image.asset(
                    'assets/images/icon.png',
                  ),
                ),
              ),
              Text(
                'Welcome Back . .',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: UIColors.textcolor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
