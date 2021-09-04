import 'package:educationbd/Controller/AuthController.dart';
import 'package:get/get.dart';

class BindingControllers extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
