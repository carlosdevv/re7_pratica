import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_images.dart';
import 'package:re7_pratica/controllers/recover_password_controller.dart';
import 'package:re7_pratica/pages/recoverPassword/widgets/send_code_widget.dart';
import 'package:re7_pratica/pages/recoverPassword/widgets/validate_code_widget.dart';
import 'package:re7_pratica/ui_control.dart';

class RecoverPasswordPage extends GetView<RecoverPasswordController> {
  const RecoverPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.wsz, vertical: 30.wsz),
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 250.wsz,
                    child: SvgPicture.asset(AppImages.forgetPasswordVector),
                  ),
                  SizedBox(height: 24.hsz),
                  Obx(
                    () => controller.isSendPasswordPage.value
                        ? SendCodeWidget(controller: controller)
                        : ValidateCodeWidget(controller: controller),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
