import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/profile_controller.dart';
import 'package:re7_pratica/pages/profile/widgets/form_profile.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/loading.dart';

class MyProfilePage extends GetView<ProfileController> {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.wsz, vertical: 30.wsz),
          child: Column(
            children: [
              _title(context),
              SizedBox(height: 30.wsz),
              Obx(() => SizedBox(
                    height: 125.wsz,
                    width: 110.wsz,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 110.wsz,
                          backgroundColor: controller.profilePhoto != null
                              ? Colors.transparent
                              : AppColors.containerInput,
                          backgroundImage: controller
                                  .imageFromGalery!.value.path.isNotEmpty
                              ? FileImage(
                                  File(controller.imageFromGalery!.value.path))
                              : null,
                          child: controller.imageFromGalery!.value.path.isEmpty
                              ? controller.profilePhoto != null
                                  ? Padding(
                                      padding: EdgeInsets.all(8.wsz),
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              controller.profilePhoto!.value,
                                          placeholder: (context, url) =>
                                              showLoading(AppColors.primary, 2),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.person,
                                                  color: AppColors.grey,
                                                  size: 60.wsz),
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      color: AppColors.grey,
                                      size: 60.wsz,
                                    )
                              : Container(),
                        ),
                        controller.isEditMode.value
                            ? Positioned(
                                bottom: 5.wsz,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    controller.pickImage();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(6.wsz),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary100,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      color: AppColors.containerInput,
                                      size: 24.wsz,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  )),
              SizedBox(height: 55.wsz),
              const FormProfileWidget()
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
              if (!controller.hasPhotoFromGallery.value) {
                controller.imageFromGalery!.value = File('');
              }
              controller.isEditMode.value = false;
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: AppColors.black,
              size: 26.wsz,
            )),
        Center(
            child: Text(
          'Meu Perfil',
          style: TextStyle(fontSize: 25.wsz),
        )),
      ],
    );
  }
}
