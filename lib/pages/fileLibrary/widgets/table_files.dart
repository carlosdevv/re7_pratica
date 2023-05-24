import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/file_library_controller.dart';
import 'package:re7_pratica/models/arquivos.dart';
import 'package:re7_pratica/models/assunto_biblioteca.dart';
import 'package:re7_pratica/pages/fileLibrary/widgets/files_dialog.dart';
import 'package:re7_pratica/pages/fileLibrary/widgets/shimmer_card.dart';
import 'package:re7_pratica/ui_control.dart';

class TableArquivosWidget extends StatefulWidget {
  const TableArquivosWidget({Key? key}) : super(key: key);

  @override
  State<TableArquivosWidget> createState() => _TableArquivosWidgetState();
}

class _TableArquivosWidgetState extends State<TableArquivosWidget> {
  final bibliotecaController = Get.find<FileLibraryController>();
  final scrollController = ScrollController();

  List<ShimmerCard> shimmerCards =
      List<ShimmerCard>.filled(9, const ShimmerCard());

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      bibliotecaController.paginate(scrollController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 28.wsz,
            color: AppColors.text,
          ),
          SizedBox(width: 10.wsz),
          Text('Lista de Arquivos',
              style: TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.wsz)),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 8.wsz),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                bibliotecaController.refreshList();
              },
              child: Icon(
                Icons.refresh_rounded,
                size: 26.wsz,
                color: AppColors.primary,
              ),
            ),
          )
        ],
      ),
      Obx(() => Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: bibliotecaController.refreshList,
              child: bibliotecaController.onLoadingListAssuntos.value
                  ? GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 30,
                      children: shimmerCards,
                    )
                  : bibliotecaController.listAssuntos.isEmpty
                      ? Center(
                          child: Text(
                            'Nenhum assunto foi encontrado.',
                            style: TextStyle(
                                color: AppColors.text100,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.wsz),
                          ),
                        )
                      : bibliotecaController.filteredByFile.value
                          ? ListView.separated(
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 0.hsz),
                              itemCount: bibliotecaController.listFiles.length,
                              itemBuilder: (ctx, index) {
                                if (index <
                                    bibliotecaController.listFiles.length) {
                                  final file =
                                      bibliotecaController.listFiles[index];

                                  return _fileContainer(ctx, file);
                                } else {
                                  return Obx(() => bibliotecaController
                                          .onLoadingListFiles.value
                                      ? const ShimmerCard()
                                      : Container());
                                }
                              })
                          : GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              controller: scrollController,
                              itemCount:
                                  bibliotecaController.listAssuntos.length + 1,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 30,
                                crossAxisCount: 3,
                              ),
                              padding: EdgeInsets.only(top: 10.wsz),
                              itemBuilder: (ctx, index) {
                                if (index <
                                    bibliotecaController.listAssuntos.length) {
                                  final assunto =
                                      bibliotecaController.listAssuntos[index];

                                  return _cardItem(assunto);
                                } else {
                                  return Obx(() => bibliotecaController
                                          .onLoadingListAssuntos.value
                                      ? const ShimmerCard()
                                      : Container());
                                }
                              }),
            ),
          )),
    ]);
  }

  InkWell _cardItem(AssuntoBiblioteca assunto) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        Get.dialog(FilesDialog(
          bibliotecaController: bibliotecaController,
          idAssunto: assunto.idAssunto,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.08),
                offset: Offset(0, 3.wsz),
                blurRadius: 12.wsz,
              )
            ]),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10.wsz, 18.wsz, 10.wsz, 10.wsz),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.wsz),
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                              '0xff${assunto.corPasta.replaceAll('#', '')}'))
                          .withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12.wsz),
                    ),
                    child: Icon(
                      Icons.folder_rounded,
                      color: Color(int.parse(
                          '0xff${assunto.corPasta.replaceAll('#', '')}')),
                      size: 42.wsz,
                    ),
                  ),
                  SizedBox(height: 15.wsz),
                  Expanded(
                    child: Center(
                      child: Text(
                        assunto.descricao,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.wsz,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                right: 5,
                top: 5,
                child: Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: assunto.descricao,
                  child: Icon(
                    Icons.help,
                    color: AppColors.primary100,
                    size: 22.wsz,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _fileContainer(BuildContext context, Arquivo file) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.hsz),
        InkWell(
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
        ),
      ],
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
            arquivo.assunto.capitalize!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
              fontSize: 20.wsz,
            ),
          ),
          SizedBox(height: 12.hsz),
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
          bibliotecaController.openFile(
              arquivo.idArquivo.toString(), arquivo.nmArquivo);
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
