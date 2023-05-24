import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/home_controller.dart';
import 'package:re7_pratica/pages/home/widgets/change_unity.dart';
import 'package:re7_pratica/pages/home/widgets/register_query.dart';
import 'package:re7_pratica/pages/home/widgets/resposta_relampago.dart';
import 'package:re7_pratica/ui_control.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _animatedActionButton(
            title: 'Registrar Consulta',
            icon: Icons.add,
            onTap: () {
              if (homeController.assunto!.id != -1) {
                homeController.assunto!.id = -1;
              }

              Get.dialog(
                  const RegisterQueryDialog(title: 'Registrar Consulta'));
              homeController.getAssuntos();
            }),
        _actionButton(
            title: 'Alterar Unidade',
            icon: Icons.settings_suggest_outlined,
            onTap: () {
              Get.bottomSheet(
                const ChangeUnityBottomSheet(),
                backgroundColor: AppColors.white,
              );
            }),
        _actionButton(
            title: 'Resp. Relâmpago',
            icon: Icons.help_outline_outlined,
            onTap: () {
              Get.dialog(const RespostaRelampagoDialog());
              homeController.getRespostasRelampago();
            }),
      ],
    );
  }

  InkWell _animatedActionButton(
      {String? title, IconData? icon, Function()? onTap}) {
    const double beginAnimate = 1.1;
    const double endAnimate = 1;
    const int duration = 750;
    const Curve curve = Curves.easeInOut;

    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 60.wsz,
                width: 60.wsz,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scaleXY(
                      begin: beginAnimate,
                      end: endAnimate,
                      duration: duration.ms,
                      curve: curve)
                  .then()
                  .scaleXY(begin: endAnimate, end: beginAnimate),
              Container(
                height: 60.wsz,
                width: 60.wsz,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.ocean,
                        AppColors.primary100,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                          color: AppColors.black.withOpacity(0.08))
                    ]),
                child: Icon(
                  icon,
                  size: 25.wsz,
                  color: AppColors.textBlue,
                ),
              )
            ],
          ),
          SizedBox(height: 8.wsz),
          Text(
            title!,
            style: TextStyle(
              fontSize: 12.wsz,
              fontWeight: FontWeight.w700,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shake(delay: (duration * 4).ms)
        ],
      ),
    );
  }

  InkWell _actionButton({String? title, IconData? icon, Function()? onTap}) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60.wsz,
            width: 60.wsz,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.ocean,
                    AppColors.primary100,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                      color: AppColors.black.withOpacity(0.08))
                ]),
            child: Icon(
              icon,
              size: 25.wsz,
              color: AppColors.textBlue,
            ),
          ),
          SizedBox(height: 8.wsz),
          Text(
            title!,
            style: TextStyle(
              fontSize: 12.wsz,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
