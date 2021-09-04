/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import '../../Controller/AuthController.dart';

// ignore: camel_case_types
class QuickTechIT_Login extends StatefulWidget {
  @override
  _QuickTechIT_LoginState createState() => _QuickTechIT_LoginState();
}

// ignore: camel_case_types
class _QuickTechIT_LoginState extends State<QuickTechIT_Login> {
  TextEditingController phoneController = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColors.backgroundColor2,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: Get.width,
                        child: Image.asset(
                          'assets/images/icon.png',
                          height: 120,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(3.5),
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Container(
                        child: TextFormField(
                          controller: phoneController,
                          validator: (phone) {
                            if (phone.length == 0) {
                              return 'Please enter your phone number';
                            } else if (phone.length != 11)
                              return 'Phone number must be 11 digit';
                            else
                              return null;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: UIColors.primaryColor2,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: UIColors.primaryColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: UIColors.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(8.0))),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Get.toNamed(
                                '/otpVerification/${phoneController.text}');
                          }
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.2),
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.redAccent),
                      child: TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.all(8.0))),
                          onPressed: () async {
                            AuthController()
                                .signInWithGoogle()
                                .then((User user) {
                              Get.snackbar("Success", "Logged In");
                            }).catchError((e) => print(e));
                          },
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 30.0,
                                width: 30.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://pbs.twimg.com/profile_images/1343584679664873479/Xos3xQfk.jpg'),
                                      fit: BoxFit.cover),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Sign in with google',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
