import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/constants/app_images.dart';
import 'package:re7_pratica/controllers/profile_controller.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/loading.dart';

class ChangePasswordProfileWidget extends StatefulWidget {
  const ChangePasswordProfileWidget({Key? key}) : super(key: key);

  @override
  State<ChangePasswordProfileWidget> createState() =>
      _ChangePasswordProfileWidgetState();
}

class _ChangePasswordProfileWidgetState
    extends State<ChangePasswordProfileWidget> {
  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.wsz),
          child: SafeArea(
            child: Center(
              child: Stack(
                children: [
                  Positioned(
                    top: 30.wsz,
                    child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          controller.newPassword.text = '';
                          controller.confirmPassword.text = '';
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.black,
                          size: 26.wsz,
                        )),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 250.wsz,
                        child: SvgPicture.asset(AppImages.forgetPasswordVector),
                      ),
                      SizedBox(height: 24.hsz),
                      Text('Nova senha',
                          style: TextStyle(
                            fontSize: 25.wsz,
                            fontWeight: FontWeight.w600,
                          )),
                      SizedBox(height: 10.hsz),
                      Text('Registre sua nova senha para logar\nno aplicativo.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.text100,
                            fontSize: 14.wsz,
                            fontWeight: FontWeight.w400,
                          )),
                      SizedBox(height: 36.hsz),
                      Container(
                        padding: EdgeInsets.all(30.wsz),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.wsz),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.07),
                              offset: Offset(0, 4.wsz),
                              blurRadius: 10.wsz,
                            ),
                          ],
                        ),
                        child: Form(
                          key: controller.newPasswordFormKey,
                          child: Column(
                            children: [
                              _passwordInput(),
                              SizedBox(height: 20.hsz),
                              _confirmPasswordInput(),
                              SizedBox(height: 32.hsz),
                              _changePassword()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _changePassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Alterar Senha',
          style: TextStyle(
              color: AppColors.black,
              fontSize: 18.wsz,
              fontWeight: FontWeight.w600),
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.handleChangePassword();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.wsz,
              vertical: 13.wsz,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(32),
            ),
            child: controller.onLoadingChangePassword.value
                ? Transform.scale(
                    scale: 0.5,
                    child: showLoading(AppColors.white, 1),
                  )
                : Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 24.wsz,
                  ),
          ),
        )
      ],
    );
  }

  Column _confirmPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.wsz),
          child: Text(
            'Confirme Sua Senha',
            style: TextStyle(
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
                fontSize: 16.wsz),
          ),
        ),
        SizedBox(height: 7.hsz),
        Obx(() => TextFormField(
              controller: controller.confirmPassword,
              obscureText: controller.isObscure.value ? true : false,
              decoration: InputDecoration(
                  errorStyle: const TextStyle(height: 0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  fillColor: AppColors.containerInput,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 16.wsz, horizontal: 18.wsz),
                  suffixIcon: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.containerInput,
                    ),
                    onPressed: () {
                      controller.showPassword();
                    },
                    child: SvgPicture.asset(
                      controller.isObscure.value
                          ? AppImages.eyeCloseIcon
                          : AppImages.eyeOpenIcon,
                      color: AppColors.text100,
                    ),
                  )),
              validator: (value) {
                if (value!.isEmpty) {
                  return '';
                }
                return null;
              },
            ))
      ],
    );
  }

  Column _passwordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.wsz),
          child: Text(
            'Nova Senha',
            style: TextStyle(
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
                fontSize: 16.wsz),
          ),
        ),
        SizedBox(height: 7.hsz),
        Obx(() => TextFormField(
              controller: controller.newPassword,
              obscureText: controller.isObscure.value ? true : false,
              decoration: InputDecoration(
                  errorStyle: const TextStyle(height: 0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  fillColor: AppColors.containerInput,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 16.wsz, horizontal: 18.wsz),
                  suffixIcon: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.containerInput,
                    ),
                    onPressed: () {
                      controller.showPassword();
                    },
                    child: SvgPicture.asset(
                      controller.isObscure.value
                          ? AppImages.eyeCloseIcon
                          : AppImages.eyeOpenIcon,
                      color: AppColors.text100,
                    ),
                  )),
              validator: (value) {
                if (value!.isEmpty) {
                  return '';
                }
                return null;
              },
            ))
      ],
    );
  }
}
