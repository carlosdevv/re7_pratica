import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/home_controller.dart';
import 'package:re7_pratica/pages/home/widgets/action_buttons.dart';
import 'package:re7_pratica/pages/home/widgets/change_unity.dart';
import 'package:re7_pratica/pages/home/widgets/hero_card.dart';
import 'package:re7_pratica/pages/home/widgets/last_consultas.dart';
import 'package:re7_pratica/routes/app_routes.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/loading.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double positionAnimate = 3.5;
    const Curve curve = Curves.easeInOut;
    const int duration = 500;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 16.0.wsz, vertical: 30.0.wsz),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Obx(() => TextButton(
                      onPressed: () {
                        Get.bottomSheet(
                          const ChangeUnityBottomSheet(),
                          backgroundColor: AppColors.white,
                        );
                      },
                      child: Text(
                        controller.unityName.value,
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 16.wsz,
                          fontWeight: FontWeight.w500,
                        ),
                      ))),
                ),
                _header(),
                SizedBox(height: 26.wsz),
                Text(
                  'Consultas',
                  style: TextStyle(
                    fontSize: 25.wsz,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 10.wsz),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200.wsz,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        ListView(
                            controller: controller.homeScrollController,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Obx(() => HeroCardWidget(
                                    title: 'Consultas Abertas',
                                    icon: Icons.priority_high_rounded,
                                    color: AppColors.error,
                                    value: controller
                                        .totalConsultas.value.totalAberta,
                                    status: 1,
                                  )),
                              SizedBox(width: 16.wsz),
                              Obx(() => HeroCardWidget(
                                    title: 'Consultas Em Andamento',
                                    icon: Icons.access_time,
                                    color: AppColors.warning,
                                    value: controller
                                        .totalConsultas.value.totalAndamento,
                                    status: 2,
                                  )),
                              SizedBox(width: 16.wsz),
                              Obx(() => HeroCardWidget(
                                    title: 'Consultas Encerradas',
                                    icon: Icons.check,
                                    color: AppColors.success,
                                    value: controller
                                        .totalConsultas.value.totalEncerrada,
                                    status: 3,
                                  )),
                              SizedBox(width: 16.wsz),
                              Obx(() => HeroCardWidget(
                                    title: 'Consultas Canceladas',
                                    icon: Icons.close,
                                    color: AppColors.error,
                                    value: controller
                                        .totalConsultas.value.totalCancelada,
                                    status: 4,
                                  ))
                            ]),
                        Obx(() => FloatingActionButton(
                            backgroundColor: AppColors.primary100,
                            splashColor: Colors.transparent,
                            onPressed: () {
                              if (controller.positionScroll.value == 0) {
                                controller.homeScrollController.position
                                    .animateTo(
                                  controller.homeScrollController.position
                                      .maxScrollExtent,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn,
                                );

                                controller.positionScroll.value = 1;
                              } else {
                                controller.positionScroll.value = 0;

                                controller.homeScrollController.position
                                    .animateTo(
                                  controller.positionScroll.value,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn,
                                );
                              }
                            },
                            child: controller.positionScroll.value == 0
                                ? Text('👉🏿',
                                        style: TextStyle(fontSize: 28.wsz))
                                    .animate(
                                        onPlay: (controller) =>
                                            controller.repeat())
                                    .moveX(
                                      begin: -positionAnimate,
                                      end: positionAnimate,
                                      duration: duration.ms,
                                      curve: curve,
                                    )
                                    .then()
                                    .moveX(
                                      begin: positionAnimate,
                                      end: -positionAnimate,
                                      curve: curve,
                                    )
                                : Text('👈🏿',
                                        style: TextStyle(fontSize: 28.wsz))
                                    .animate(
                                        onPlay: (controller) =>
                                            controller.repeat())
                                    .moveX(
                                      begin: positionAnimate,
                                      end: -positionAnimate,
                                      duration: duration.ms,
                                      curve: curve,
                                    )
                                    .then()
                                    .moveX(
                                      begin: -positionAnimate,
                                      end: positionAnimate,
                                      curve: curve,
                                    ))),
                      ],
                    )),
                SizedBox(height: 40.wsz),
                const ActionButtonsWidget(),
                SizedBox(height: 40.wsz),
                Obx(() => controller.onLoadingListConsultas.value
                    ? Padding(
                        padding: EdgeInsets.only(top: 24.wsz),
                        child: showLoading(AppColors.black, 3))
                    : controller.recentsConsultas.isEmpty
                        ? Container()
                        : controller.recentsConsultas.length > 4
                            ? LastConsultasWidget(
                                recentsConsultas:
                                    controller.recentsConsultas.sublist(0, 4))
                            : LastConsultasWidget(
                                recentsConsultas: controller.recentsConsultas,
                              ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => controller.userProps.value.nome != ''
            ? Text(
                'Olá,\n${controller.userProps.value.nome.capitalize}!',
                style: TextStyle(
                  fontSize: 22.wsz,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              )
            : Text(
                'Olá',
                style: TextStyle(
                  fontSize: 22.wsz,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              )),
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            Get.toNamed(Routes.profile);
          },
          child: Obx(() => Container(
                padding: EdgeInsets.all(4.wsz),
                width: 80.wsz,
                height: 80.wsz,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey100,
                ),
                child: controller.userProps.value.foto != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: controller.userProps.value.foto.toString(),
                          placeholder: (context, url) =>
                              showLoading(AppColors.primary, 2),
                          errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              color: AppColors.ocean,
                              size: 30.wsz),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: AppColors.ocean,
                        size: 30.wsz,
                      ),
              )),
        ),
      ],
    );
  }
}
