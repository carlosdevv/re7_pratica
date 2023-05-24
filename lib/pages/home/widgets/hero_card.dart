import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/query_controller.dart';
import 'package:re7_pratica/pages/home/widgets/filtered_consults.dart';
import 'package:re7_pratica/ui_control.dart';

class HeroCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String? value;
  final int status;
  const HeroCardWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.value,
    required this.color,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final queryController = Get.find<QueryController>();

    return GestureDetector(
      onTap: () async => {
        queryController.cardStatus.value = status,
        queryController.page.value = 1,
        await queryController.getListConsultasFilterByStatus(),
        Get.bottomSheet(
          FilteredConsultsWidget(
            title: title,
            icon: icon,
            color: color,
          ),
          backgroundColor: AppColors.white,
        )
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0.wsz, vertical: 20.0.wsz),
        width: 175.wsz,
        height: 185.wsz,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(44.wsz),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.ocean,
              AppColors.primary100,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50.wsz,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 12.5.wsz,
                        child: Container(
                          width: 25.wsz,
                          height: 25.wsz,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary100,
                          ),
                        ),
                      ),
                      Container(
                        width: 25.wsz,
                        height: 25.wsz,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.white,
                          size: 13.wsz,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textBlue,
                fontSize: 16.wsz,
              ),
            ),
            Text(
              value ?? '0',
              style: TextStyle(
                color: AppColors.textBlue,
                fontSize: 50.wsz,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
