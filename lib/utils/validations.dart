import 'package:flutter/material.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/ui_control.dart';

Icon? validateSituation(situacao) {
  switch (situacao) {
    case 'Aberta':
      return Icon(
        Icons.priority_high_rounded,
        color: validateColorSituation(situacao),
        size: 20.wsz,
      );
    case 'Em Andamento':
      return Icon(
        Icons.access_time,
        color: validateColorSituation(situacao),
        size: 20.wsz,
      );
    case 'Encerrada':
      return Icon(
        Icons.check,
        color: validateColorSituation(situacao),
        size: 20.wsz,
      );
    case 'Cancelada':
      return Icon(
        Icons.close,
        color: validateColorSituation(situacao),
        size: 20.wsz,
      );
    default:
      return null;
  }
}

Color? validateColorSituation(situacao) {
  switch (situacao) {
    case 'Aberta':
      return AppColors.error;
    case 'Em Andamento':
      return AppColors.warning;

    case 'Encerrada':
      return AppColors.success;

    case 'Cancelada':
      return AppColors.error;
    default:
      return null;
  }
}
