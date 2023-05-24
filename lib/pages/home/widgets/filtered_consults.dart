import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/query_controller.dart';
import 'package:re7_pratica/models/consultas.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/consulta_bs.dart';
import 'package:re7_pratica/utils/loading.dart';

class FilteredConsultsWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const FilteredConsultsWidget(
      {Key? key, required this.title, required this.icon, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateformat = DateFormat('dd/MM/yyyy');

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.wsz,
        vertical: 24.wsz,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          SizedBox(height: 25.wsz),
          _columns(),
          Expanded(
            child: GetBuilder<QueryController>(
              init: QueryController(),
              builder: (queryController) {
                return ListView.builder(
                    controller:
                        queryController.consultaScrollControllerForFilter,
                    itemCount: queryController.listQueryFiltered.length + 1,
                    itemBuilder: (context, index) {
                      if (index < queryController.listQueryFiltered.length) {
                        final consulta =
                            queryController.listQueryFiltered[index];

                        if (queryController.onLoadingListConsultas.value) {
                          return showLoading(AppColors.primary, 3);
                        } else {
                          return _itemList(
                              consulta, dateformat, queryController);
                        }
                      } else {
                        return Padding(
                            padding: EdgeInsets.only(top: 20.wsz),
                            child: queryController.isMoreItems.value
                                ? queryController.loadMore.value
                                    ? Transform.scale(
                                        scale: 0.75,
                                        child:
                                            showLoading(AppColors.primary, 2))
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
                    });
              },
            ),
          )
        ],
      ),
    );
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
          SizedBox(width: 25.wsz),
          Text(
            consulta.dtConsulta.replaceAll('-', '/'),
            style: TextStyle(
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
                fontSize: 15.wsz),
          ),
          SizedBox(width: 25.wsz),
          Expanded(
            child: Text(
              consulta.assunto ?? 'Assunto',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppColors.text100,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.wsz),
            ),
          ),
        ]),
      ),
    );
  }

  Container _columns() {
    return Container(
      padding: EdgeInsets.all(16.wsz),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(width: 5.wsz),
          Text(
            'Tipo',
            style: TextStyle(
              fontSize: 14.wsz,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          SizedBox(width: 40.wsz),
          Text(
            'Data',
            style: TextStyle(
              fontSize: 14.wsz,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          SizedBox(width: 45.wsz),
          Text(
            'Assunto',
            style: TextStyle(
              fontSize: 14.wsz,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Row _header() {
    return Row(
      children: [
        Container(
          width: 25.wsz,
          height: 25.wsz,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 13.wsz,
          ),
        ),
        SizedBox(width: 10.wsz),
        Text(
          title,
          style: TextStyle(
            fontSize: 22.wsz,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}
