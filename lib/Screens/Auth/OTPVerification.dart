/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'package:educationbd/Screens/Code/CheckLogin.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import '../../Controller/AuthController.dart';

class QuickTechIT_OTPVerification extends StatefulWidget {
  @override
  _QuickTechIT_OTPVerificationState createState() =>
      _QuickTechIT_OTPVerificationState();
}

class _QuickTechIT_OTPVerificationState
    extends State<QuickTechIT_OTPVerification> {
  AuthController myController = Get.put(AuthController());

  String phoneNumber = Get.parameters['phoneNumber'];

  TextEditingController pinPutController = new TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: UIColors.primaryColor),
      borderRadius: BorderRadius.circular(12),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    myController.firebaseAuth(phoneNumber);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColors.backgroundColor,
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
                      height: 20.0,
                    ),
                    Text(
                      "OTP Authentication",
                      style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(3),
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Code is sent to in this\n(+88)$phoneNumber phone number.",
                      style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2),
                          color: Colors.grey),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    PinPut(
                      fieldsCount: 6,
                      focusNode: _pinPutFocusNode,
                      controller: pinPutController,
                      validator: (code) {
                        if (code.length != 6)
                          return 'OTP must be in 6 digit';
                        else
                          return null;
                      },
                      submittedFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(10)),
                      selectedFieldDecoration: _pinPutDecoration,
                      followingFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Didn't get the code!",
                            style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.8),
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            myController.firebaseAuth(phoneNumber);
                          },
                          child: Container(
                            child: Text(
                              "Resend",
                              style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.8),
                                  fontWeight: FontWeight.bold,
                                  color: UIColors.primaryColor),
                            ),
                          ),
                        ),
                      ],
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
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            String code = pinPutController.text.trim();
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: myController.verificationId,
                                    smsCode: code);

                            myController.getPhoneCredential(credential);

                            await CheckLogin().checkData();
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
                    // SizedBox(height: 20,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     Container(
                    //       child: Text(
                    //         "By signing up, you agree to our ",
                    //         style: TextStyle(
                    //           fontSize: ResponsiveFlutter.of(context)
                    //               .fontSize(1.5),
                    //           color: Colors.grey.shade800,),
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         //Navigator.push(context, MaterialPageRoute(builder: (context) => TermsandConditions()));
                    //       },
                    //       child: Container(
                    //         child: Text(
                    //           "Terms & Condition",
                    //           style: TextStyle(
                    //               fontSize: ResponsiveFlutter.of(
                    //                   context).fontSize(1.5),
                    //               fontWeight: FontWeight.bold,
                    //               color: UI_Colors.primaryColor),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // )
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
