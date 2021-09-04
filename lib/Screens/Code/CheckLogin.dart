import 'package:educationbd/Models/UserModel.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CheckLogin {
  final localData = GetStorage();

  bool isLogin = false;
  bool haveData = false;

  UserModel userData;

  checkData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      isLogin = true;
      userData = await Database().getUserData();
      if (userData != null) {
        haveData = true;
        Get.offAllNamed('/home');
      } else {
        haveData = false;
        Get.offAllNamed('/reg');
      }
    } else {
      isLogin = false;
      Get.offAllNamed('/login');
    }
    localData.write('isLogin', isLogin);
    localData.write('haveData', haveData);
    localData.write('userName', userData == null ? "" : userData.name);
    localData.write('userMobile', userData == null ? "" : userData.phoneNumber);
    localData.write('userCourse', userData == null ? "" : userData.courseId);
  }
}