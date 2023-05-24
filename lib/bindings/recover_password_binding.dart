import 'package:get/get.dart';
import 'package:re7_pratica/controllers/recover_password_controller.dart';

class RecoverPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecoverPasswordController>(
      () => RecoverPasswordController(),
    );
  }
}
