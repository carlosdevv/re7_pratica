import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/profile_controller.dart';
import 'package:re7_pratica/pages/profile/widgets/profile_actions.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/loading.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.wsz, 30.wsz, 24.wsz, 48.wsz),
          child: Column(
            children: [
              _title(context),
              SizedBox(height: 30.wsz),
              Row(
                children: [
                  Obx(() => Container(
                        padding: EdgeInsets.all(6.wsz),
                        width: 110.wsz,
                        height: 110.wsz,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.grey100,
                        ),
                        child: controller.profilePhoto != null
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: controller.profilePhoto!.value,
                                  placeholder: (context, url) =>
                                      showLoading(AppColors.primary, 2),
                                  errorWidget: (context, url, error) => Icon(
                                      Icons.person,
                                      color: AppColors.grey,
                                      size: 85.wsz),
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                color: AppColors.grey,
                                size: 60.wsz,
                              ),
                      )),
                  SizedBox(width: 16.wsz),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            controller.name.value.capitalize!,
                            style: TextStyle(
                              fontSize: 24.wsz,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          )),
                      SizedBox(height: 6.wsz),
                      Obx(() => Text(
                            controller.email.value,
                            style: TextStyle(
                              fontSize: 16.wsz,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text100,
                            ),
                          )),
                    ],
                  )
                ],
              ),
              SizedBox(height: 55.wsz),
              const ProfileActionsWidget()
            ],
          ),
        ),
      ),
    );
  }

  Stack _title(BuildContext context) {
    return Stack(
      children: [
        InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: AppColors.black,
              size: 26.wsz,
            )),
        Center(
            child: Text(
          'Perfil',
          style: TextStyle(
            fontSize: 25.wsz,
            fontWeight: FontWeight.bold,
          ),
        )),
      ],
    );
  }
}
