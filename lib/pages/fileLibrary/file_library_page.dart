import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/file_library_controller.dart';
import 'package:re7_pratica/pages/fileLibrary/widgets/table_files.dart';
import 'package:re7_pratica/ui_control.dart';

class FileLibraryPage extends StatefulWidget {
  const FileLibraryPage({Key? key}) : super(key: key);

  @override
  State<FileLibraryPage> createState() => _FileLibraryPageState();
}

class _FileLibraryPageState extends State<FileLibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<FileLibraryController>(
          init: FileLibraryController(),
          builder: (controller) {
            return Column(
              children: [
                _header(controller),
                SizedBox(height: 30.wsz),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.wsz),
                  child: const TableArquivosWidget(),
                ))
              ],
            );
          },
        ),
      ),
    );
  }

  Container _header(FileLibraryController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0.wsz, 30.0.wsz, 16.0.wsz, 20.0.wsz),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Biblioteca de Arquivos',
            style: TextStyle(
              fontSize: 25.wsz,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.wsz),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                controller.searchFilterValue.text = '';
                controller.searchType.value = 1;
                Get.bottomSheet(
                  _filter(controller),
                  backgroundColor: Colors.white,
                  barrierColor: Colors.transparent,
                );
              },
              child: Container(
                padding: EdgeInsets.all(10.wsz),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    border: Border.all(color: AppColors.primary100),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                        color: AppColors.black.withOpacity(0.16),
                      ),
                    ]),
                child: Icon(
                  Icons.search,
                  color: AppColors.black,
                  size: 26.wsz,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Container _filter(FileLibraryController controller) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24.wsz, vertical: 20.wsz),
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.white,
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 0),
          blurRadius: 6,
          color: AppColors.black.withOpacity(0.16),
        )
      ],
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.wsz), topRight: Radius.circular(20.wsz)),
    ),
    child: SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            _headerBS(controller),
            SizedBox(height: 32.wsz),
            _radioSearchType(controller),
            SizedBox(height: 12.wsz),
            _searchBar(controller),
            SizedBox(height: 32.wsz),
            InkWell(
              onTap: () async {
                await controller.searchFile();
                Get.back();
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.wsz),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primaryDark, AppColors.primary]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Aplicar',
                  style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.w700),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Obx _radioSearchType(FileLibraryController controller) {
  return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtrar por:',
            style: TextStyle(
              color: AppColors.text100,
              fontSize: 18.wsz,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: controller.searchType.value,
                    activeColor: AppColors.primary,
                    onChanged: (int? newValue) =>
                        controller.searchType.value = newValue!,
                  ),
                  Text(
                    'Pasta',
                    style: TextStyle(
                      color: AppColors.text100,
                      fontSize: 16.wsz,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 5.wsz),
              Row(
                children: [
                  Radio(
                    value: 2,
                    groupValue: controller.searchType.value,
                    activeColor: AppColors.primary,
                    onChanged: (int? newValue) =>
                        controller.searchType.value = newValue!,
                  ),
                  Text(
                    'Arquivo',
                    style: TextStyle(
                      color: AppColors.text100,
                      fontSize: 16.wsz,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ));
}

Row _headerBS(FileLibraryController controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text('Filtros',
          style: TextStyle(
            fontSize: 22.wsz,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          )),
      InkWell(
        onTap: () async {
          await controller.refreshList();
          Get.back();
        },
        child: Text('Limpar Filtros',
            style: TextStyle(
              fontSize: 16.wsz,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            )),
      ),
      InkWell(
        onTap: () {
          Get.back();
        },
        child: Text('Fechar',
            style: TextStyle(
              fontSize: 16.wsz,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            )),
      ),
    ],
  );
}

Obx _searchBar(FileLibraryController controller) {
  return Obx(() => TextField(
        controller: controller.searchFilterValue,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: controller.searchType.value == 1
              ? 'Pesquisar por pasta'
              : 'Pesquisar por arquivo',
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
      ));
}
