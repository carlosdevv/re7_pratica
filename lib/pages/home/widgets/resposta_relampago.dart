import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/home_controller.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/loading.dart';

class RespostaRelampagoDialog extends StatefulWidget {
  const RespostaRelampagoDialog({Key? key}) : super(key: key);

  @override
  State<RespostaRelampagoDialog> createState() =>
      _RespostaRelampagoDialogState();
}

class _RespostaRelampagoDialogState extends State<RespostaRelampagoDialog> {
  final HomeController _homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.wsz, vertical: 200.hsz),
      child: Material(
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.fromLTRB(20.wsz, 25.wsz, 20.wsz, 15.wsz),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryDark,
                      AppColors.primary,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.wsz),
                      topRight: Radius.circular(20.wsz)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Resposta Relâmpago',
                            style: TextStyle(
                              fontSize: 20.wsz,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                        SizedBox(height: 8.wsz),
                        Text('Dúvidas Frequentes',
                            style: TextStyle(
                              fontSize: 14.wsz,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            )),
                      ],
                    ),
                    GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.close,
                          size: 26.wsz,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              SizedBox(height: 4.wsz),
              Padding(
                padding: EdgeInsets.fromLTRB(10.wsz, 10.wsz, 10.wsz, 5.wsz),
                child: _searchBar(_homeController),
              ),
              Obx(() => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30.wsz),
                      child: SingleChildScrollView(
                        child: _homeController.onLoadingFAQ.value
                            ? Padding(
                                padding: EdgeInsets.only(top: 50.wsz),
                                child: showLoading(AppColors.black, 3))
                            : Column(
                                children: _homeController.respostasRelampagoList
                                    .map((item) {
                                  return ExpansionTile(
                                    collapsedTextColor: Colors.black,
                                    iconColor: AppColors.black,
                                    collapsedIconColor: AppColors.black,
                                    tilePadding: EdgeInsets.symmetric(
                                        horizontal: 20.wsz),
                                    title: Text(
                                      item.descPergunta,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    childrenPadding: EdgeInsets.symmetric(
                                      horizontal: 5.wsz,
                                    ),
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.wsz,
                                            vertical: 10.wsz,
                                          ),
                                          decoration: BoxDecoration(
                                              color: AppColors.ocean,
                                              borderRadius:
                                                  BorderRadius.circular(12.wsz),
                                              border: Border.all(
                                                color: AppColors.primary,
                                              )),
                                          child: Text(
                                            item.descResposta,
                                            textAlign: TextAlign.justify,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: AppColors.text100,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }).toList(),
                              ),
                      ),
                    ),
                  )),
            ])),
      ),
    );
  }

  TextField _searchBar(HomeController controller) {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Pesquisar',
        hintStyle: TextStyle(
            color: AppColors.text100,
            fontWeight: FontWeight.w600,
            fontSize: 16.wsz),
        errorStyle: const TextStyle(height: 0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: AppColors.containerInput,
        filled: true,
        contentPadding:
            EdgeInsets.symmetric(vertical: 14.wsz, horizontal: 18.wsz),
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.text100,
          size: 22.wsz,
        ),
      ),
      onChanged: (value) => controller.searchFile(value),
    );
  }
}
