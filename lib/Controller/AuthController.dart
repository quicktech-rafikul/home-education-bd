import 'package:educationbd/Screens/Code/CheckLogin.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  String verificationId;

  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Rx<User> _firebaseUser = Rx<User>();

  String get user => _firebaseUser.value?.uid;

  final localData = GetStorage();

  @override
  onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  firebaseAuth(String phoneNumber) async {
    _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: "+88" + phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          getPhoneCredential(credential);
        },
        timeout: Duration(seconds: 30),
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            Get.defaultDialog(
              title: "Loging Failed",
              content: Text(
                "Incorrect number",
              ),
              actions: [
                TextButton(
                  child: Text("Try again later"),
                  onPressed: () async {
                    Get.back();
                  },
                )
              ],
            );
          } else {
            Get.snackbar("Failed", e.message);
          }
        },
        codeSent: (String verificationID, [int forceResendingToken]) {
          verificationId = verificationID;
          Get.snackbar("Code Sent", "Code sent into your phone number");
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  getPhoneCredential(PhoneAuthCredential credential) async {
    _auth.signInWithCredential(credential).then((UserCredential result) async {
      User user = result.user;
      GetStorage().write('isPhone', true);
      GetStorage().write('isGoogle', false);
      GetStorage().write('isFacebook', false);
      getData(user);
    }).catchError((e) {
      Get.defaultDialog(
        title: "Failed To Loging",
        content: Text(
          "Incorrect OTP",
        ),
        actions: [
          TextButton(
            child: Text("Try again later"),
            onPressed: () async {
              Get.back();
            },
          )
        ],
      );
    });
  }

  signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    UserCredential authResult = await _auth.signInWithCredential(credential);
    GetStorage().write('isPhone', false);
    GetStorage().write('isGoogle', true);
    GetStorage().write('isFacebook', false);
    getData(authResult.user);
  }

  getData(User user) async {
    if (user != null) {
      CheckLogin().checkData();
    } else {
      Get.defaultDialog(
        title: "Failed",
        content: Text(
          "Failed To Logging",
        ),
        actions: [
          TextButton(
            child: Text("Try Again Later"),
            onPressed: () async {
              Get.back();
            },
          )
        ],
      );
    }
  }

  signOut() async {
    if (localData.read('isPhone')) {
      await FirebaseAuth.instance.signOut();
    }
    if (localData.read('isGoogle')) {
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    }
    if (localData.read('isFacebook')) {
      FirebaseAuth.instance.signOut();
    }

    await CheckLogin().checkData();
  }
}
