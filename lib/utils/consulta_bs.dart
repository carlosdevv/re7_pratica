import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/home_controller.dart';
import 'package:re7_pratica/controllers/query_controller.dart';
import 'package:re7_pratica/models/consultas.dart';
import 'package:re7_pratica/pages/home/widgets/register_query.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/audio_dialog.dart';
import 'package:re7_pratica/utils/snackbar.dart';

class ConsultBottomSheet extends StatelessWidget {
  final QueryController queryController;
  final Consulta consult;

  const ConsultBottomSheet({
    Key? key,
    required this.queryController,
    required this.consult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      padding: EdgeInsets.all(24.wsz),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.wsz),
          topRight: Radius.circular(20.wsz),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Selecione uma opção',
              style: TextStyle(
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
                fontSize: 20.wsz,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 25.wsz),
              child: ListView(
                children: [
                  _itemBottomSheet(
                    context,
                    consult.id,
                    title: 'Visualizar Áudios',
                    icon: Icons.play_circle_fill_rounded,
                    onTap: () async {
                      final hasAudios = await queryController
                          .getAudios(consult.id.toString());

                      if (hasAudios != null && hasAudios) {
                        Get.dialog(AudioDialogWidget(
                          consult: consult,
                        ));
                      }
                    },
                  ),
                  SizedBox(height: 20.wsz),
                  _itemBottomSheet(
                    context,
                    consult.id,
                    title: 'Visualizar Relatório',
                    icon: Icons.picture_as_pdf_outlined,
                    onTap: () {
                      queryController.openPDF(consult.id.toString());
                    },
                  ),
                  SizedBox(height: 20.wsz),
                  _itemBottomSheet(
                    context,
                    consult.id,
                    title: 'Visualizar Anexos',
                    icon: Icons.attach_file_rounded,
                    onTap: () async {
                      final hasAnexos = await queryController
                          .getAnexos(consult.id.toString());

                      if (hasAnexos != null && hasAnexos) {
                        Get.dialog(
                            _contentDialogAnexos(context, queryController));
                      }
                    },
                  ),
                  SizedBox(height: 20.wsz),
                  _itemBottomSheet(
                    context,
                    consult.id,
                    title: 'Complementar Consulta',
                    icon: Icons.control_point_duplicate_outlined,
                    onTap: () async {
                      Get.dialog(RegisterQueryDialog(
                        title: 'Complementar Consulta',
                        hasSubject: false,
                        hasWordKey: false,
                        isComplementConsult: true,
                        onTap: () async {
                          await homeController
                              .registerComplementConsult(consult.id);
                          homeController.idConsulta.value = consult.id;

                          if (homeController.isSuccessConsult.value) {
                            await _pickFile(homeController);
                          }
                        },
                      ));
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Row _itemBottomSheet(
    BuildContext context,
    int idConsulta, {
    String? title,
    IconData? icon,
    Function()? onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 8.wsz, horizontal: 8.wsz),
            decoration: BoxDecoration(
              color: AppColors.ocean,
              border: Border.all(color: AppColors.primary, width: 2.wsz),
              borderRadius: BorderRadius.circular(12.wsz),
            ),
            child: Row(children: [
              Icon(
                icon!,
                color: AppColors.primary,
                size: 32.wsz,
              ),
              SizedBox(width: 10.hsz),
              Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.text100,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.wsz),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Padding _contentDialogAnexos(
    BuildContext context,
    QueryController controller,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.height * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.30,
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24.wsz,
            vertical: 16.hsz,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.white,
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Anexos',
                          style: TextStyle(
                              color: AppColors.text100,
                              fontWeight: FontWeight.w600,
                              fontSize: 24.wsz)),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.text100,
                          size: 24.wsz,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.hsz),
                Expanded(
                    child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 10.hsz),
                  itemCount: controller.listAnexos.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        controller.openAnexo(controller.listAnexos[index]);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${controller.listAnexos[index].split('/').last.capitalize}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppColors.text100,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.wsz),
                              ),
                            ),
                            Icon(
                              Icons.file_download_rounded,
                              color: AppColors.primary,
                              size: 24.wsz,
                            )
                          ]),
                    );
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _pickFile(HomeController homeController) {
    return Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(18.wsz),
      content: Column(
        children: [
          Icon(
            Icons.upload_rounded,
            color: AppColors.text100,
            size: 60.wsz,
          ),
          SizedBox(height: 20.hsz),
          Text(
            'Deseja inserir um anexo a essa consulta?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
              fontSize: 18.wsz,
            ),
          ),
          SizedBox(height: 16.hsz),
        ],
      ),
      confirm: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () async {
          final result = await FilePicker.platform.pickFiles();
          if (result == null) {
            return;
          } else {
            homeController.anexo.value = result.files.first;
            _confirmationModal(homeController);
          }
        },
        child: Flexible(
          fit: FlexFit.tight,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(14.wsz),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12)),
            child: Text(
              'Escolher arquivo',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16.wsz,
              ),
            ),
          ),
        ),
      ),
      cancel: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.back();
          Get.back();
        },
        child: Flexible(
          fit: FlexFit.tight,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(14.wsz),
            child: Text(
              'Sem anexo',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w500,
                fontSize: 16.wsz,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _confirmationModal(HomeController homeController) {
    return Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(18.wsz),
      content: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.success,
            size: 60.wsz,
          ),
          SizedBox(height: 20.hsz),
          Text(
            'Tem certeza que deseja anexar esse arquivo?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
              fontSize: 18.wsz,
            ),
          ),
          SizedBox(height: 16.hsz),
        ],
      ),
      confirm: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () async {
          await homeController.insertAnexos(idOrigem: 2);
          Get.back();
          showSuccessSnackbar('Anexo enviado com sucesso.');
        },
        child: Flexible(
          fit: FlexFit.tight,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(14.wsz),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12)),
            child: Text(
              'Confirmar',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16.wsz,
              ),
            ),
          ),
        ),
      ),
      cancel: InkWell(
        splashColor: AppColors.error.withOpacity(0.35),
        highlightColor: AppColors.error.withOpacity(0.35),
        hoverColor: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          PlatformFile emptyAnexo = PlatformFile(name: '', size: -1);
          homeController.anexo.value = emptyAnexo;

          Get.back();
        },
        child: Flexible(
          fit: FlexFit.tight,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(14.wsz),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w500,
                fontSize: 16.wsz,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
