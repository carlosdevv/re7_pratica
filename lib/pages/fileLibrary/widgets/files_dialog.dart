import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/file_library_controller.dart';
import 'package:re7_pratica/models/arquivos.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/loading.dart';

class FilesDialog extends StatefulWidget {
  final FileLibraryController bibliotecaController;
  final int idAssunto;
  const FilesDialog(
      {Key? key, required this.bibliotecaController, required this.idAssunto})
      : super(key: key);

  @override
  State<FilesDialog> createState() => _FilesDialogState();
}

class _FilesDialogState extends State<FilesDialog> {
  @override
  void initState() {
    super.initState();
    widget.bibliotecaController.getListFiles(widget.idAssunto, null);
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.wsz, vertical: 25.wsz),
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
                    Text('Arquivos',
                        style: TextStyle(
                          fontSize: 20.wsz,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        )),
                    GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.close,
                          size: 22.wsz,
                          color: AppColors.white,
                        )),
                  ],
                ),
              ),
              SizedBox(height: 24.wsz),
              Expanded(
                child: Obx(() => Padding(
                      padding: EdgeInsets.fromLTRB(20.wsz, 0, 20.wsz, 30.wsz),
                      child: ListView.separated(
                          separatorBuilder: ((context, index) =>
                              SizedBox(height: 16.wsz)),
                          itemCount:
                              widget.bibliotecaController.listFiles.length,
                          itemBuilder: ((context, index) {
                            if (widget.bibliotecaController.onLoadingListFiles
                                .value) {
                              return Center(
                                  child: showLoading(AppColors.primary, 3));
                            } else {
                              final file =
                                  widget.bibliotecaController.listFiles[index];

                              return _fileContainer(context, file);
                            }
                          })),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell _fileContainer(BuildContext context, Arquivo file) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        _downloadFileDialog(file);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12.wsz, 8.wsz, 18.wsz, 8.wsz),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.wsz),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.08),
                offset: const Offset(2, 2),
                blurRadius: 6.wsz,
              )
            ]),
        child: Row(children: [
          Container(
            padding: EdgeInsets.all(8.wsz),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.wsz),
              color: AppColors.grey100,
            ),
            child: Icon(
              Icons.description_rounded,
              color: AppColors.primary,
              size: 28.wsz,
            ),
          ),
          SizedBox(width: 16.wsz),
          Expanded(
            child: Text(
              file.nmArquivo.capitalize!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w500,
                fontSize: 16.wsz,
              ),
            ),
          ),
          SizedBox(width: 5.wsz),
          Icon(
            Icons.download_rounded,
            color: AppColors.grey,
            size: 32.wsz,
          ),
        ]),
      ),
    );
  }

  Future _downloadFileDialog(Arquivo arquivo) {
    DateFormat dateformat = DateFormat('dd/MM/yyyy');

    return Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(18.wsz),
      content: Column(
        children: [
          Icon(
            Icons.download_for_offline_rounded,
            color: AppColors.text100,
            size: 60.wsz,
          ),
          SizedBox(height: 20.hsz),
          Text(
            arquivo.nmArquivo.capitalize!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
              fontSize: 18.wsz,
            ),
          ),
          SizedBox(height: 5.hsz),
          Text(
            dateformat.format(arquivo.dtCadastro),
            style: TextStyle(
              color: AppColors.textLightGrey,
              fontWeight: FontWeight.w500,
              fontSize: 15.wsz,
            ),
          ),
          SizedBox(height: 9.hsz),
          Text(
            'Deseja baixar o item selecionado?',
            style: TextStyle(
              color: AppColors.text100,
              fontWeight: FontWeight.w500,
              fontSize: 16.wsz,
            ),
          ),
          SizedBox(height: 18.hsz),
        ],
      ),
      confirm: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () {
          widget.bibliotecaController
              .openFile(arquivo.idArquivo.toString(), arquivo.nmArquivo);
          Get.back();
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(14.wsz),
          width: MediaQuery.of(context).size.width,
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
      cancel: InkWell(
        borderRadius: BorderRadius.circular(12.wsz),
        onTap: () {
          Get.back();
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(14.wsz),
          width: MediaQuery.of(context).size.width,
          child: Text(
            'Não, obrigado',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
              fontSize: 16.wsz,
            ),
          ),
        ),
      ),
    );
  }
}
