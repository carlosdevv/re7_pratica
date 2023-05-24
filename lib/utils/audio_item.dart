import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/query_controller.dart';
import 'package:re7_pratica/ui_control.dart';

class AudioItemWidget extends StatefulWidget {
  final int index;
  final String title;
  final bool isAnswer;
  const AudioItemWidget({
    Key? key,
    required this.index,
    required this.title,
    required this.isAnswer,
  }) : super(key: key);

  @override
  State<AudioItemWidget> createState() => _AudioItemWidgetState();
}

class _AudioItemWidgetState extends State<AudioItemWidget>
    with TickerProviderStateMixin {
  final _queryController = Get.find<QueryController>();
  late final AnimationController _animationController;
  final _audioPlayer = FlutterSoundPlayer();

  bool isPlayingAudio = false;

  @override
  void initState() {
    initPlayer();
    _animationController = AnimationController(vsync: this);
    _animationController.duration = const Duration(seconds: 2);

    super.initState();
  }

  Future initPlayer() async {
    await _audioPlayer.openPlayer();
  }

  Future playAudio(String path) async {
    setState(() {
      isPlayingAudio = true;
    });
    await _audioPlayer.startPlayer(
      fromURI: path,
      whenFinished: () => setState(() => isPlayingAudio = false),
    );
  }

  Future stopAudio() async {
    setState(() {
      isPlayingAudio = false;
    });
    await _audioPlayer.stopPlayer();
  }

  Future onTogglePlaying(String path) async {
    if (_audioPlayer.isStopped) {
      await playAudio(path);
    } else {
      await stopAudio();
    }
  }

  toggleSound() {
    if (isPlayingAudio) {
      _animationController.repeat();
    } else {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _audioPlayer.closePlayer();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        onTogglePlaying(widget.isAnswer
            ? _queryController.listAnswerAudios[widget.index]
            : _queryController.listAudios[widget.index]);

        toggleSound();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.wsz, horizontal: 12.wsz),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.wsz),
          border: Border.all(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Text(
              widget.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppColors.text100,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.wsz),
            ),
          ),
          isPlayingAudio
              ? Transform.scale(
                  scale: 3.5,
                  child: Lottie.asset(
                    'lottie/audio-wave.json',
                    controller: _animationController,
                    height: 25.wsz,
                  ))
              : Container(),
          SizedBox(width: 10.wsz),
          isPlayingAudio
              ? Icon(
                  Icons.stop_circle,
                  color: AppColors.error.withOpacity(0.85),
                  size: 24.wsz,
                )
              : Icon(
                  Icons.play_circle,
                  color: AppColors.primary,
                  size: 24.wsz,
                )
        ]),
      ),
    );
  }
}
