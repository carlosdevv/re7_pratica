import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/constants/app_images.dart';
import 'package:re7_pratica/controllers/dashboard_controller.dart';
import 'package:re7_pratica/pages/query/query_page.dart';
import 'package:re7_pratica/pages/home/home_page.dart';
import 'package:re7_pratica/pages/re7_play/re7_play_page.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/bottom_bar.dart';

import 'fileLibrary/file_library_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: const [
                HomePage(),
                ConsultasPage(),
                FileLibraryPage(),
                Re7PlayPage(),
              ],
            ),
          ),
          bottomNavigationBar: CustomAnimatedBottomBar(
            containerHeight: 70.hsz,
            backgroundColor: AppColors.primaryDark,
            selectedIndex: controller.tabIndex,
            showElevation: true,
            itemCornerRadius: 22.wsz,
            curve: Curves.easeIn,
            onItemSelected: controller.changeTabIndex,
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                icon: SvgPicture.asset(
                  AppImages.homeIcon,
                  width: 20.wsz,
                  color: controller.tabIndex == 0
                      ? AppColors.bottomBarItem
                      : AppColors.grey,
                ),
                title: Text(
                  'Home',
                  style: _styleTextBottomBar(),
                ),
                activeColor: AppColors.bottomBarItem,
                inactiveColor: AppColors.grey,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.article_outlined, size: 24.wsz),
                title: Text(
                  'Consultas',
                  style: _styleTextBottomBar(),
                ),
                activeColor: AppColors.bottomBarItem,
                inactiveColor: AppColors.grey,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.inventory_2_outlined, size: 24.wsz),
                title: Text(
                  'Biblioteca',
                  style: _styleTextBottomBar(),
                ),
                activeColor: AppColors.bottomBarItem,
                inactiveColor: AppColors.grey,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.play_circle, size: 24.wsz),
                title: Text(
                  'Re7 Play',
                  style: _styleTextBottomBar(),
                ),
                activeColor: AppColors.bottomBarItem,
                inactiveColor: AppColors.grey,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  TextStyle _styleTextBottomBar() => TextStyle(fontSize: 14.wsz);
}
