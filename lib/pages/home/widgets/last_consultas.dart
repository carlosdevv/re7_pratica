import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/query_controller.dart';
import 'package:re7_pratica/models/consultas.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/consulta_bs.dart';
import 'package:re7_pratica/utils/validations.dart';

class LastConsultasWidget extends StatefulWidget {
  final List<Consulta> recentsConsultas;
  const LastConsultasWidget({Key? key, required this.recentsConsultas})
      : super(key: key);

  @override
  State<LastConsultasWidget> createState() => _LastConsultasWidgetState();
}

class _LastConsultasWidgetState extends State<LastConsultasWidget> {
  final _consultasController = Get.find<QueryController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.article_outlined,
              size: 28.wsz,
              color: AppColors.text,
            ),
            SizedBox(width: 10.wsz),
            Text(
              'Ultimas Consultas',
              style: TextStyle(fontSize: 24.wsz),
            ),
          ],
        ),
        SizedBox(height: 12.wsz),
        Row(
          children: [
            Text(
              'Situação',
              style: TextStyle(
                fontSize: 14.wsz,
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 20.wsz),
            Text(
              'Tipo',
              style: TextStyle(
                fontSize: 14.wsz,
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 45.wsz),
            Text(
              'Data',
              style: TextStyle(
                fontSize: 14.wsz,
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 45.wsz),
            Text(
              'Assunto',
              style: TextStyle(
                fontSize: 14.wsz,
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Column(
          children: widget.recentsConsultas.map((item) {
            return lastConsultasItemWidget(item, context, _consultasController);
          }).toList(),
        ),
      ],
    );
  }
}

Widget lastConsultasItemWidget(
    Consulta item, BuildContext context, QueryController consultasController) {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () {
      Get.bottomSheet(ConsultBottomSheet(
          queryController: consultasController, consult: item));
    },
    child: Container(
      padding: EdgeInsets.only(bottom: 20.0.wsz, top: 20.wsz),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: AppColors.primary,
          width: 1.wsz,
        ),
      )),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.wsz),
            width: 35.wsz,
            height: 35.wsz,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: validateColorSituation(item.situacao)!.withOpacity(0.15),
            ),
            child: validateSituation(item.situacao),
          ),
          SizedBox(width: 35.wsz),
          item.tipoPergunta == 2
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
            item.dtConsulta.replaceAll('-', '/'),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
                fontSize: 16.wsz),
          ),
          SizedBox(width: 25.wsz),
          Expanded(
            child: Text(
              item.assunto ?? 'Assunto',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppColors.text100,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.wsz),
            ),
          ),
        ],
      ),
    ),
  );
}
