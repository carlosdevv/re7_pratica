import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/home_controller.dart';
import 'package:re7_pratica/models/user_unity.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/snackbar.dart';

class ChangeUnityBottomSheet extends StatefulWidget {
  const ChangeUnityBottomSheet({Key? key}) : super(key: key);

  @override
  State<ChangeUnityBottomSheet> createState() => _ChangeUnityBottomSheetState();
}

class _ChangeUnityBottomSheetState extends State<ChangeUnityBottomSheet> {
  final HomeController _homeController = Get.find<HomeController>();
  List<UserUnity> unitySelected = [];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.50,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.wsz,
          vertical: 24.wsz,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4.wsz,
                width: 60.wsz,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.grey,
                ),
              ),
            ),
            SizedBox(height: 32.wsz),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lista de unidades',
                  style: TextStyle(fontSize: 24.wsz),
                ),
              ],
            ),
            SizedBox(height: 4.wsz),
            Text(
              'Selecione a unidade que deseja alterar',
              style: TextStyle(
                fontSize: 14.wsz,
                color: AppColors.text100,
              ),
            ),
            SizedBox(height: 16.wsz),
            Expanded(
              child: Obx(() => ListView.separated(
                    itemBuilder: ((context, index) {
                      final unity = _homeController.userUnitiesList[index];
                      return _unityItem(unity);
                    }),
                    separatorBuilder: (_, __) =>
                        const Divider(color: AppColors.grey, height: 1),
                    itemCount: _homeController.userUnitiesList.length,
                  )),
            ),
            unitySelected.isNotEmpty
                ? GestureDetector(
                    onTap: (() async {
                      if (unitySelected.first.idcliente.toString() ==
                          _homeController.idCliente.value) {
                        showWarningSnackbar('Você já está nessa unidade.');
                      } else {
                        await _homeController
                            .handleChangeUnity(unitySelected.first);
                        Get.back();
                      }
                    }),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.wsz, horizontal: 32.wsz),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: AppColors.primary,
                        ),
                        child: Text(
                          'Alterar',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16.wsz,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _unityItem(UserUnity unity) {
    return ListTile(
      onTap: (() {
        setState(() {
          if (unitySelected.contains(unity)) {
            unitySelected.remove(unity);
          } else {
            if (unitySelected.isNotEmpty) {
              unitySelected.clear();
            }
            unitySelected.add(unity);
          }
        });
      }),
      selected: unitySelected.contains(unity),
      selectedTileColor: AppColors.ocean,
      title: Text(
        unity.nmcliente,
        style: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w500,
          fontSize: 16.wsz,
        ),
      ),
      leading: const Icon(
        Icons.group,
        color: AppColors.primary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
