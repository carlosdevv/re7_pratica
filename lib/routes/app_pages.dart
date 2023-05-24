import 'package:get/get.dart';
import 'package:re7_pratica/bindings/dashboard_binding.dart';
import 'package:re7_pratica/bindings/login_binding.dart';
import 'package:re7_pratica/bindings/profile_binding.dart';
import 'package:re7_pratica/bindings/recover_password_binding.dart';
import 'package:re7_pratica/pages/dashboard_page.dart';
import 'package:re7_pratica/pages/login/login_page.dart';
import 'package:re7_pratica/pages/profile/my_profile.dart';
import 'package:re7_pratica/pages/profile/profile_page.dart';
import 'package:re7_pratica/pages/recoverPassword/change_password_page.dart';
import 'package:re7_pratica/pages/recoverPassword/recover_password_page.dart';

import 'app_routes.dart';

class AppPages {
  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.recoverPassword,
      page: () => const RecoverPasswordPage(),
      binding: RecoverPasswordBinding(),
    ),
    GetPage(
      name: Routes.changePassword,
      page: () => const ChangePasswordPage(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.myProfile,
      page: () => const MyProfilePage(),
      binding: ProfileBinding(),
    ),
  ];
}
