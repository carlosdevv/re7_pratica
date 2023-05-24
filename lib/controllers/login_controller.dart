import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/models/environment.dart';
import 'package:re7_pratica/models/user_secure_storage.dart';
import 'package:re7_pratica/providers/login_provider.dart';
import 'package:re7_pratica/routes/app_routes.dart';
import 'package:re7_pratica/utils/snackbar.dart';

class LoginController extends GetxController {
  Rx<bool> isObscure = true.obs;
  Rx<bool> onLoadingClients = true.obs;
  Rx<bool> onLoadingLogin = false.obs;

  final formLoginKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  final clientCode = TextEditingController();

  void showPassword() {
    isObscure.value = !isObscure.value;
    update();
  }

  void handleAuth() async {
    try {
      if (formLoginKey.currentState!.validate()) {
        formLoginKey.currentState!.save();
        onLoadingLogin.value = true;
        await LoginProvider()
            .getAuth(username.text, password.text, clientCode.text)
            .then((value) {
          UserSecureStorage.setUser(username.text);
          UserSecureStorage.setCode(clientCode.text);
          UserSecureStorage.setToken(Environment.apiToken!);
          Get.offAllNamed(Routes.dashboard);
        });
        onLoadingLogin.value = false;
        update();
      } else {
        if (username.text.isEmpty ||
            password.text.isEmpty ||
            clientCode.text.isEmpty) {
          showErrorSnackbar('Preencha todos os campos para fazer o login.');
        }
      }
    } catch (e) {
      onLoadingLogin.value = false;
      update();
      if (e == 401) {
        showErrorSnackbar('Cliente, usuário ou senha incorretos.');
      } else {
        showErrorSnackbar('Ocorreu um erro ao fazer o login.');
      }
    }
  }
}
