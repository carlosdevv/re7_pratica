import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/re7_play_controller.dart';
import 'package:re7_pratica/models/videos.dart';
import 'package:re7_pratica/pages/re7_play/widgets/youtube_player.dart';
import 'package:re7_pratica/ui_control.dart';
import 'package:re7_pratica/utils/loading.dart';
import 'package:url_launcher/link.dart';

class VideoGalleryWidget extends StatefulWidget {
  const VideoGalleryWidget({Key? key}) : super(key: key);

  @override
  State<VideoGalleryWidget> createState() => _VideoGalleryWidgetState();
}

class _VideoGalleryWidgetState extends State<VideoGalleryWidget> {
  final _videosController = Get.find<Re7PlayController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.play_circle,
              size: 28.wsz,
              color: AppColors.text,
            ),
            SizedBox(width: 10.wsz),
            Text('Galeria de Videos',
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
                  _videosController.refreshListVideos();
                },
                child: Icon(
                  Icons.refresh,
                  color: AppColors.primary,
                  size: 26.wsz,
                ),
              ),
            ),
          ],
        ),
        Obx(() => Expanded(
              child: _videosController.onLoadingListVideos.value
                  ? showLoading(AppColors.primary, 3)
                  : _videosController.listVideos.isEmpty
                      ? Center(
                          child: Text(
                            'Lista de videos vazia.',
                            style: TextStyle(
                                color: AppColors.text100,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.wsz),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _videosController.listVideos.length,
                          padding: EdgeInsets.only(top: 15.wsz),
                          itemBuilder: (ctx, index) {
                            final video = _videosController.listVideos[index];

                            return _cardVideo(video, ctx);
                          }),
            ))
      ],
    );
  }

  InkWell _cardVideo(Videos video, BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        _openVideoScreen(context, video);
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  video.descricao,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.wsz,
                  ),
                ),
              ),
              Link(
                uri: Uri.parse(video.linkVideo),
                builder: (context, followLink) => GestureDetector(
                  onTap: followLink,
                  child: Text(
                    'Ver no youtube',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColors.textBlue,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.wsz),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.hsz),
          Container(
            alignment: Alignment.center,
            height: 200.hsz,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              image: DecorationImage(
                image: NetworkImage(video.thumbnail!),
                fit: BoxFit.cover,
              ),
            ),
            child: Icon(
              Icons.play_arrow,
              color: AppColors.primary,
              size: 36.wsz,
            ),
          ),
          SizedBox(height: 35.hsz),
        ],
      ),
    );
  }

  Future _openVideoScreen(BuildContext context, Videos video) {
    return Get.dialog(
      Material(
        color: Colors.transparent,
        child: SizedBox(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Stack(
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () => Get.back(),
                  child: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
                Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.wsz),
                      child:
                          YoutubePlayerContainerWidget(url: video.linkVideo)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
