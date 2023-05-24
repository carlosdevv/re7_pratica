import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/query_controller.dart';
import 'package:re7_pratica/models/consultas.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/audio_item.dart';

class AudioDialogWidget extends StatefulWidget {
  final Consulta consult;
  const AudioDialogWidget({Key? key, required this.consult}) : super(key: key);

  @override
  State<AudioDialogWidget> createState() => _AudioDialogWidgetState();
}

class _AudioDialogWidgetState extends State<AudioDialogWidget> {
  final _queryController = Get.find<QueryController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.height * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.25,
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
                      Text('Audios',
                          style: TextStyle(
                              color: AppColors.primaryDark,
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
                SizedBox(height: 20.hsz),
                widget.consult.tipoPergunta == 2
                    ? Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Pergunta',
                                style: TextStyle(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.wsz)),
                          ),
                          SizedBox(height: 10.hsz),
                          const AudioItemWidget(
                            title: 'Pergunta.mp3',
                            index: 0,
                            isAnswer: false,
                          ),
                          SizedBox(height: 20.hsz),
                        ],
                      )
                    : Container(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Respostas',
                      style: TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.wsz)),
                ),
                SizedBox(height: 10.hsz),
                widget.consult.tipoPergunta == 2
                    ? Expanded(
                        child: _queryController.listAnswerAudios.isEmpty
                            ? Text('Ainda não há respostas para essa consulta.',
                                style: TextStyle(
                                  color: AppColors.text100,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.wsz,
                                ))
                            : ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 10.hsz),
                                itemCount:
                                    _queryController.listAnswerAudios.length,
                                itemBuilder: (context, index) {
                                  return AudioItemWidget(
                                    title: 'Complemento ${index + 1}.mp3',
                                    index: index,
                                    isAnswer: true,
                                  );
                                },
                              ))
                    : Expanded(
                        child: _queryController.listAudios.isEmpty
                            ? Text(
                                'Ainda não há complementos para essa consulta.',
                                style: TextStyle(
                                  color: AppColors.text100,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.wsz,
                                ))
                            : ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 10.hsz),
                                itemCount: _queryController.listAudios.length,
                                itemBuilder: (context, index) {
                                  return AudioItemWidget(
                                    title: 'Complemento ${index + 1}.mp3',
                                    index: index,
                                    isAnswer: false,
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
}
