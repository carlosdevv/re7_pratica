import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/query_controller.dart';
import 'package:re7_pratica/models/consultas.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/consulta_bs.dart';
import 'package:re7_pratica/utils/loading.dart';
import 'package:re7_pratica/utils/validations.dart';

class TableConsultasWidget extends StatefulWidget {
  const TableConsultasWidget({Key? key}) : super(key: key);

  @override
  State<TableConsultasWidget> createState() => _TableConsultasWidgetState();
}

class _TableConsultasWidgetState extends State<TableConsultasWidget> {
  final consultasController = Get.find<QueryController>();
  bool hasAnexos = false;

  @override
  Widget build(BuildContext context) {
    DateFormat dateformat = DateFormat('dd/MM/yyyy');
    return GetBuilder<QueryController>(
        init: QueryController(),
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.only(top: 10.wsz),
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: controller.refreshList,
              child: ListView.builder(
                  controller: consultasController.consultaScrollController,
                  itemCount: controller.listConsultas.length + 1,
                  itemBuilder: (context, index) {
                    if (index < controller.listConsultas.length) {
                      final consulta = controller.listConsultas[index];
                      if (controller.onLoadingListConsultas.value) {
                        return showLoading(AppColors.primary, 3);
                      } else {
                        return _itemList(consulta, dateformat, controller);
                      }
                    } else {
                      return Padding(
                          padding: EdgeInsets.only(top: 20.wsz),
                          child: controller.isMoreItems.value
                              ? controller.loadMore.value
                                  ? Transform.scale(
                                      scale: 0.75,
                                      child: showLoading(AppColors.primary, 2))
                                  : Container()
                              : Center(
                                  child: Padding(
                                  padding: EdgeInsets.only(bottom: 16.wsz),
                                  child: Text(
                                    'Não há mais consultas.',
                                    style: TextStyle(
                                        color: AppColors.text100,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.wsz),
                                  ),
                                )));
                    }
                  }),
            ),
          );
        });
  }

  Container _itemList(
      Consulta consulta, DateFormat dateformat, QueryController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.wsz, 20.wsz, 16.wsz, 20.wsz),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: AppColors.primary,
          width: 1.wsz,
        ),
      )),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () async {
          Get.bottomSheet(ConsultBottomSheet(
            queryController: controller,
            consult: consulta,
          ));
        },
        child: Row(children: [
          Container(
              width: 35.wsz,
              height: 35.wsz,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: validateColorSituation(consulta.situacao)!
                    .withOpacity(0.15),
              ),
              child: validateSituation(consulta.situacao)),
          SizedBox(width: 35.wsz),
          consulta.tipoPergunta == 2
              ? Container(
                  width: 35.wsz,
                  height: 35.wsz,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.15),
                  ),
                  child: Icon(
                    Icons.play_circle_outline_outlined,
                    color: AppColors.primary,
                    size: 20.wsz,
                  ),
                )
              : Container(
                  width: 35.wsz,
                  height: 35.wsz,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.15),
                  ),
                  child: Icon(
                    Icons.feed_outlined,
                    color: AppColors.primary,
                    size: 20.wsz,
                  ),
                ),
          SizedBox(width: 20.wsz),
          Text(
            consulta.dtConsulta.replaceAll('-', '/'),
            style: TextStyle(
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
                fontSize: 14.wsz),
          ),
          SizedBox(width: 25.wsz),
          Expanded(
              child: Text(
            consulta.assunto ?? 'Assunto',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
                fontSize: 15.wsz),
          )),
        ]),
      ),
    );
  }
}
