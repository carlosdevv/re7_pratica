import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/constants/app_images.dart';
import 'package:re7_pratica/controllers/login_controller.dart';
import 'package:re7_pratica/routes/app_routes.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/loading.dart';

class FormLoginWidget extends StatefulWidget {
  const FormLoginWidget({Key? key}) : super(key: key);

  @override
  State<FormLoginWidget> createState() => _FormLoginWidgetState();
}

class _FormLoginWidgetState extends State<FormLoginWidget> {
  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Form(
          key: controller.formLoginKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.0.wsz),
              child: Column(
                children: [
                  // _selectClientDropdown(),
                  _clientCodeInput(),
                  SizedBox(height: 40.hsz),
                  _usernameInput(),
                  SizedBox(height: 20.hsz),
                  _passwordInput(),
                  SizedBox(height: 10.hsz),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () {
                      Get.toNamed(Routes.recoverPassword);
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'Esqueci minha senha',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 36.wsz),
                  Obx(() => InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          controller.handleAuth();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(bottom: 24.wsz),
                          padding: EdgeInsets.symmetric(vertical: 14.wsz),
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryDark,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          child: controller.onLoadingLogin.value
                              ? SizedBox(
                                  height: 18.wsz,
                                  width: 18.wsz,
                                  child: showLoading(Colors.white, 2.wsz),
                                )
                              : Text(
                                  'Entrar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.wsz,
                                      fontWeight: FontWeight.w700),
                                ),
                        ),
                      ))
                ],
              ),
            ),
          )),
    );
  }

  TextFormField _clientCodeInput() {
    return TextFormField(
      controller: controller.clientCode,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Código',
        hintStyle: const TextStyle(
            color: AppColors.text100, fontWeight: FontWeight.w600),
        errorStyle: const TextStyle(height: 0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary)),
        fillColor: AppColors.containerInput,
        filled: true,
        contentPadding:
            EdgeInsets.symmetric(vertical: 16.wsz, horizontal: 18.wsz),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '';
        }
        return null;
      },
    );
  }

  TextFormField _usernameInput() {
    return TextFormField(
      controller: controller.username,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Usuário',
        hintStyle: const TextStyle(
            color: AppColors.text100, fontWeight: FontWeight.w600),
        errorStyle: const TextStyle(height: 0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary)),
        fillColor: AppColors.containerInput,
        filled: true,
        contentPadding:
            EdgeInsets.symmetric(vertical: 16.wsz, horizontal: 18.wsz),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '';
        }
        return null;
      },
    );
  }

  Obx _passwordInput() {
    return Obx(() => TextFormField(
          controller: controller.password,
          obscureText: controller.isObscure.value ? true : false,
          decoration: InputDecoration(
              hintText: 'Senha',
              hintStyle: const TextStyle(
                  color: AppColors.text100, fontWeight: FontWeight.w600),
              errorStyle: const TextStyle(height: 0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary)),
              fillColor: AppColors.containerInput,
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16.wsz, horizontal: 18.wsz),
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
        ));
  }
}
