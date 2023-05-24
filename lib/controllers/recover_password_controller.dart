import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/models/code.dart';
import 'package:re7_pratica/providers/recover_password_provider.dart';
import 'package:re7_pratica/routes/app_routes.dart';
import 'package:re7_pratica/utils/snackbar.dart';

class RecoverPasswordController extends GetxController {
  Rx<bool> isSendPasswordPage = true.obs;
  Rx<bool> isObscure = true.obs;

  final timeExpired = Rx<bool>(false);

  final pin1 = TextEditingController();
  final pin2 = TextEditingController();
  final pin3 = TextEditingController();
  final pin4 = TextEditingController();
  final pin5 = TextEditingController();

  String serviceCode = '';

  final username = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  final passwordCodeKey = GlobalKey<FormState>();
  final newPasswordFormKey = GlobalKey<FormState>();

  Future<void> handleSendCode() async {
    try {
      if (username.text.isNotEmpty) {
        CodeProps response =
            await RecoverPasswordProvider.getCodeChangePassword(username.text);
        serviceCode = response.codigo;
        isSendPasswordPage.value = false;

        showSuccessSnackbar('Código enviado com sucesso, verifique seu SMS.');
      } else {
        showErrorSnackbar('Insira um usuário associado a sua conta.');
      }
    } catch (e) {
      showErrorSnackbar('Não foi possivel enviar o SMS, tente novamente.');
    }
  }

  void handleVerifyCode() {
    final userCode = pin1.text + pin2.text + pin3.text + pin4.text + pin5.text;
    if (timeExpired.value == false) {
      if (userCode == serviceCode) {
        Get.offNamed(Routes.changePassword);
      } else {
        showErrorSnackbar('Código inválido.');
      }
    } else {
      showErrorSnackbar('Código expirado.');
    }
  }

  void handleChangePassword() async {
    if (newPasswordFormKey.currentState!.validate()) {
      if (newPassword.text == confirmPassword.text) {
        await RecoverPasswordProvider.updatePassword(
            username.text, confirmPassword.text);
        Get.offAllNamed(Routes.login);
      } else {
        showErrorSnackbar('A senhas devem ser iguais.');
      }
    } else {
      showErrorSnackbar('Preencha todos os campos para continuar.');
    }
  }

  void handleResendPassword() {
    pin1.text = '';
    pin2.text = '';
    pin3.text = '';
    pin4.text = '';
    pin5.text = '';
    handleSendCode();
  }

  void showPassword() {
    isObscure.value = !isObscure.value;
    update();
  }
}
