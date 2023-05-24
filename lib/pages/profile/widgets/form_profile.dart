import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/constants/app_images.dart';
import 'package:re7_pratica/controllers/profile_controller.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/input.dart';

class FormProfileWidget extends StatefulWidget {
  const FormProfileWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FormProfileWidget> createState() => _FormProfileWidgetState();
}

class _FormProfileWidgetState extends State<FormProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        initState: (_) {},
        builder: (controller) {
          return Form(
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Minhas informações',
                          style: TextStyle(
                            fontSize: 18.wsz,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Obx(() => InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: () {
                                controller.changeEditMode();
                              },
                              child: controller.isEditMode.value
                                  ? Icon(
                                      Icons.close,
                                      color: AppColors.grey,
                                      size: 24.wsz,
                                    )
                                  : Icon(
                                      Icons.edit,
                                      color: AppColors.primary,
                                      size: 22.wsz,
                                    ),
                            ))
                      ],
                    ),
                    SizedBox(height: 20.wsz),
                    Obx(() => InputWidget(
                          controller: controller.emailInput,
                          hintText: controller.email.value,
                          label: 'E-mail',
                          width: MediaQuery.of(context).size.width,
                          readOnly: !controller.isEditMode.value,
                          activeBorder: controller.isEditMode.value,
                        )),
                    SizedBox(height: 20.wsz),
                    Obx(() => InputWidget(
                          controller: controller.nameInput,
                          hintText: controller.name.value.capitalizeFirst!,
                          label: 'Nome Completo',
                          width: MediaQuery.of(context).size.width,
                          readOnly: !controller.isEditMode.value,
                          activeBorder: controller.isEditMode.value,
                        )),
                    SizedBox(height: 20.wsz),
                    Obx(() => InputWidget(
                          controller: controller.phoneInput,
                          hintText: controller.phone.value,
                          keyboardType: TextInputType.phone,
                          mask: controller.phoneFormatter,
                          label: 'Telefone',
                          width: MediaQuery.of(context).size.width,
                          readOnly: !controller.isEditMode.value,
                          activeBorder: controller.isEditMode.value,
                        )),
                    SizedBox(height: 20.wsz),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InputWidget(
                          hintText: controller.userLogin.value,
                          label: 'Login',
                          width: MediaQuery.of(context).size.width * 0.4,
                          readOnly: true,
                        ),
                        InputWidget(
                          hintText: controller.codeClient.value.toString(),
                          label: 'Código',
                          width: MediaQuery.of(context).size.width * 0.4,
                          readOnly: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.wsz),
                    Obx(() => Align(
                          alignment: Alignment.centerRight,
                          child: controller.isEditMode.value
                              ? InkWell(
                                  onTap: () {
                                    controller.updateProfile();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12.wsz),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.primaryDark,
                                            AppColors.primary
                                          ]),
                                    ),
                                    child: Text(
                                      'Confirmar Alterações',
                                      style: TextStyle(
                                        fontSize: 14.wsz,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ))
                              : Container(),
                        )),
                    SizedBox(height: 30.wsz),
                    Image.asset(
                      AppImages.logoApp,
                      height: 85.wsz,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
