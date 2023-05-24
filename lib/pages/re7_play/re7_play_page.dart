import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/re7_play_controller.dart';
import 'package:re7_pratica/pages/re7_play/widgets/video_gallery.dart';
import 'package:re7_pratica/ui_control.dart';

class Re7PlayPage extends StatefulWidget {
  const Re7PlayPage({Key? key}) : super(key: key);

  @override
  State<Re7PlayPage> createState() => _Re7PlayPageState();
}

class _Re7PlayPageState extends State<Re7PlayPage> {
  final _re7PlayController = Get.find<Re7PlayController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _header(),
          SizedBox(height: 30.wsz),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.wsz),
            child: const VideoGalleryWidget(),
          ))
        ],
      ),
    );
  }

  Container _header() {
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
            'RE7 Play',
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
                _re7PlayController.titulo.text = '';

                Get.bottomSheet(
                  _filterContentRe7Play(context),
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
          ),
        ],
      ),
    );
  }

  Container _filterContentRe7Play(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.wsz, vertical: 12.wsz),
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
            topLeft: Radius.circular(40.wsz),
            topRight: Radius.circular(40.wsz)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _headerBS(),
            SizedBox(height: 28.wsz),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: _inputBS(
                'Título*',
                'Pesquise por título',
                TextInputType.text,
              ),
            ),
            SizedBox(height: 48.wsz),
            InkWell(
              onTap: () {
                _re7PlayController.getListVideosFilter();
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
    );
  }

  Column _inputBS(
    String label,
    String hint,
    TextInputType type,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6.wsz),
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.text100,
              fontSize: 15.wsz,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 4.wsz),
        SizedBox(
          height: 50.hsz,
          child: TextField(
            controller: _re7PlayController.titulo,
            keyboardType: type,
            decoration: InputDecoration(
              counterText: "",
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.text100,
                fontWeight: FontWeight.w600,
                fontSize: 14.wsz,
              ),
              errorStyle: const TextStyle(height: 0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary)),
              fillColor: AppColors.containerInput,
              filled: true,
              contentPadding: EdgeInsets.all(12.hsz),
            ),
          ),
        )
      ],
    );
  }

  Row _headerBS() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Filtrar Videos',
            style: TextStyle(
              fontSize: 22.wsz,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            )),
        InkWell(
          onTap: () async {
            await _re7PlayController.refreshListVideos();
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
}
