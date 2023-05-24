import 'dart:io';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:re7_pratica/controllers/home_controller.dart';
import 'package:re7_pratica/ui_control.dart';

class RecordAudioWidget extends StatefulWidget {
  const RecordAudioWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<RecordAudioWidget> createState() => _RecordAudioWidgetState();
}

class _RecordAudioWidgetState extends State<RecordAudioWidget>
    with TickerProviderStateMixin {
  final HomeController _homeController = Get.find<HomeController>();
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);

  final pathToReadAudio = 'audio.mp4';

  final _audioRecorder = FlutterSoundRecorder();
  bool _isRecorderInitialised = false;
  bool get _isRecording => _audioRecorder.isRecording;

  final _audioPlayer = FlutterSoundPlayer();
  bool hasAudio = false;
  bool get _isPlayingAudio => _audioPlayer.isPlaying;

  AnimationController? _rotationController;
  AnimationController? _scaleController;
  double _rotation = 0;
  double _scale = 0.85;

  bool get _showWaves => !_scaleController!.isDismissed;

  void _updateRotation() => _rotation = _rotationController!.value * 2 * pi;
  void _updateScale() => _scale = (_scaleController!.value * 0.2) + 0.85;

  @override
  void initState() {
    initRecorder();
    initPlayer();

    _rotationController =
        AnimationController(vsync: this, duration: _kRotationDuration)
          ..addListener(() => setState(_updateRotation))
          ..repeat();

    _scaleController =
        AnimationController(vsync: this, duration: _kToggleDuration)
          ..addListener(() => setState(_updateScale));

    super.initState();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microfone não tem permissão.';
    }

    await _audioRecorder.openRecorder();
    _isRecorderInitialised = true;

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _audioRecorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    if (!_isRecorderInitialised) return;

    await _audioRecorder.startRecorder(
      toFile: pathToReadAudio,
      codec: Codec.aacMP4,
    );
  }

  Future stopRecorder() async {
    if (!_isRecorderInitialised) return;

    String? path = await _audioRecorder.stopRecorder();
    _homeController.audioFile.value = File(path!);
  }

  Future _onToggleRecording() async {
    if (_scaleController!.isCompleted) {
      _scaleController!.reverse();
    } else {
      _scaleController!.forward();
    }

    if (_isRecording) {
      await stopRecorder();
    } else {
      await startRecord();
    }
  }

  Future initPlayer() async {
    await _audioPlayer.openPlayer();
  }

  Future playAudio(VoidCallback whenFinished) async {
    await _audioPlayer.startPlayer(
      fromURI: pathToReadAudio,
      whenFinished: whenFinished,
    );
  }

  Future stopAudio() async {
    await _audioPlayer.stopPlayer();
  }

  Future _onTogglePlaying({required VoidCallback whenFinished}) async {
    if (_audioPlayer.isStopped) {
      await playAudio(whenFinished);
    } else {
      await stopAudio();
    }
  }

  @override
  void dispose() {
    _scaleController!.dispose();
    _rotationController!.dispose();

    _audioRecorder.closeRecorder();
    _audioPlayer.closePlayer();
    _isRecorderInitialised = false;

    _homeController.audioFile.value = File('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _audioButton(),
        SizedBox(width: 15.wsz),
        _timerAudio(),
        const Spacer(),
        hasAudio ? _hearAudio() : Container(),
        SizedBox(width: 5.wsz),
      ],
    );
  }

  Widget _hearAudio() {
    if (!_isRecording) {
      return IconButton(
        icon: Icon(
          _isPlayingAudio ? Icons.stop_circle : Icons.play_circle,
        ),
        iconSize: 26.wsz,
        color: AppColors.primary,
        onPressed: () {
          _onTogglePlaying(whenFinished: () => setState(() {}));
          setState(() {});
        },
      );
    }
    return Container();
  }

  StreamBuilder<RecordingDisposition> _timerAudio() {
    return StreamBuilder<RecordingDisposition>(
        stream: _audioRecorder.onProgress,
        builder: (context, snapshot) {
          final duration =
              snapshot.hasData ? snapshot.data!.duration : Duration.zero;

          String twoDigits(int n) => n.toString().padLeft(2, '0');
          final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
          final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

          if (duration != Duration.zero) {
            hasAudio = true;
          }

          return Text(
            '$twoDigitMinutes:$twoDigitSeconds',
            style: TextStyle(
              color: AppColors.text100,
              fontSize: 16.wsz,
              fontWeight: FontWeight.w600,
            ),
          );
        });
  }

  SizedBox _audioButton() {
    return SizedBox(
      height: 45.wsz,
      width: 45.wsz,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 48.wsz, minHeight: 48.wsz),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_showWaves) ...[
              Blob(
                  color: const Color(0xff0092ff),
                  scale: _scale,
                  rotation: _rotation),
              Blob(
                  color: const Color(0xff4ac7b7),
                  scale: _scale,
                  rotation: _rotation * 2 - 30),
              Blob(
                  color: const Color(0xffa4a6f6),
                  scale: _scale,
                  rotation: _rotation * 3 - 45),
            ],
            Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.ocean,
                border: Border.all(
                  color: AppColors.primary100,
                  width: 2,
                ),
              ),
              child: AnimatedSwitcher(
                duration: _kToggleDuration,
                child: _buildIcon(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return SizedBox.expand(
      key: ValueKey<bool>(_isRecording),
      child: GestureDetector(
          onTap: _onToggleRecording,
          child: Container(
            width: 25.wsz,
            height: 25.wsz,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: _isRecording
                ? const Icon(Icons.mic, color: AppColors.error)
                : const Icon(Icons.mic, color: AppColors.primary),
          )),
    );
  }
}

class Blob extends StatelessWidget {
  final double rotation;
  final double scale;
  final Color color;

  const Blob({Key? key, required this.color, this.rotation = 0, this.scale = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(150),
              topRight: Radius.circular(240),
              bottomLeft: Radius.circular(220),
              bottomRight: Radius.circular(180),
            ),
          ),
        ),
      ),
    );
  }
}
