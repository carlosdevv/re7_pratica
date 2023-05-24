import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';

showErrorSnackbar(String message) {
  Get.snackbar(
    'Erro',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    borderRadius: 12,
    margin: const EdgeInsets.all(12),
    snackStyle: SnackStyle.FLOATING,
    duration: const Duration(milliseconds: 2500),
    icon: const Icon(
      Icons.close,
      color: Colors.white,
    ),
  );
}

showSuccessSnackbar(String message, {int? duration = 2500}) {
  Get.snackbar(
    'Sucesso',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.success,
    colorText: AppColors.white,
    borderRadius: 12,
    margin: const EdgeInsets.all(12),
    snackStyle: SnackStyle.FLOATING,
    duration: Duration(milliseconds: duration!),
    icon: const Icon(
      Icons.check_circle_rounded,
      color: Colors.white,
    ),
  );
}

showWarningSnackbar(String message) {
  Get.snackbar(
    'Aviso',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.warning,
    colorText: AppColors.white,
    borderRadius: 12,
    margin: const EdgeInsets.all(12),
    snackStyle: SnackStyle.FLOATING,
    duration: const Duration(milliseconds: 2500),
    icon: const Icon(
      Icons.error,
      color: Colors.white,
    ),
  );
}

showLoadingSnackbar(String message) {
  Get.snackbar(
    'Carregando',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.primary,
    colorText: AppColors.white,
    borderRadius: 12,
    margin: const EdgeInsets.all(12),
    snackStyle: SnackStyle.FLOATING,
    icon: const Icon(
      Icons.circle_outlined,
      color: Colors.white,
    ),
  );
}

showCustomSnackbar(
  String title,
  String message,
  Color bgColor,
  Color textColor,
  Icon icon,
) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: bgColor,
    colorText: textColor,
    borderRadius: 12,
    margin: const EdgeInsets.all(12),
    snackStyle: SnackStyle.FLOATING,
    duration: const Duration(milliseconds: 2500),
    icon: icon,
  );
}
