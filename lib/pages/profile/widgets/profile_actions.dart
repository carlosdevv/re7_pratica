import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/profile_controller.dart';
import 'package:re7_pratica/pages/profile/social_networks.dart';
import 'package:re7_pratica/pages/profile/widgets/change_password_profile.dart';
import 'package:re7_pratica/routes/app_routes.dart';
import 'package:re7_pratica/ui_control.dart';

class ProfileActionsWidget extends StatelessWidget {
  const ProfileActionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GetBuilder<ProfileController>(
            init: ProfileController(),
            initState: (_) {},
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buttonActionProfile(
                    function: () => Get.toNamed(Routes.myProfile),
                    title: 'Meu Perfil',
                    icon: Icons.lock_outline_rounded,
                  ),
                  SizedBox(height: 16.wsz),
                  _buttonActionProfile(
                    function: () => controller.getTerms(),
                    title: 'Termos e Condições',
                    icon: Icons.category_outlined,
                  ),
                  SizedBox(height: 16.wsz),
                  _buttonActionProfile(
                    function: () =>
                        Get.to(() => const ChangePasswordProfileWidget()),
                    title: 'Atualizar Senha',
                    icon: Icons.lock_outline_rounded,
                  ),
                  SizedBox(height: 16.wsz),
                  _buttonActionProfile(
                    function: () => Get.to(() => const SocialNetworksPage()),
                    title: 'Redes Sociais',
                    icon: Icons.subscriptions_outlined,
                  ),
                  const Spacer(),
                  _logoutButton(controller),
                ],
              );
            }));
  }

  InkWell _logoutButton(ProfileController controller) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        controller.logout();
      },
      child: Row(
        children: [
          Icon(Icons.logout, color: AppColors.error, size: 28.wsz),
          SizedBox(width: 18.wsz),
          Text(
            'Logout',
            style: TextStyle(
              fontSize: 18.wsz,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          )
        ],
      ),
    );
  }

  InkWell _buttonActionProfile(
      {required Function() function,
      required String title,
      required IconData icon}) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: function,
      child: Container(
        padding: EdgeInsets.fromLTRB(12.wsz, 12.wsz, 24.wsz, 12.wsz),
        decoration: BoxDecoration(
          color: AppColors.primary100.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 28.wsz),
            SizedBox(width: 18.wsz),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.wsz,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primaryDark,
              size: 18.wsz,
            )
          ],
        ),
      ),
    );
  }
}
