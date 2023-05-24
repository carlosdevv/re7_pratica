import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerContainerWidget extends StatefulWidget {
  final String url;
  const YoutubePlayerContainerWidget({Key? key, required this.url})
      : super(key: key);

  @override
  State<YoutubePlayerContainerWidget> createState() =>
      _YoutubePlayerContainerWidgetState();
}

class _YoutubePlayerContainerWidgetState
    extends State<YoutubePlayerContainerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    runYoutubePlayer();
    super.initState();
  }

  void runYoutubePlayer() {
    final videoID = YoutubePlayer.convertUrlToId(widget.url);

    _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          loop: true,
          disableDragSeek: true,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        width: MediaQuery.of(context).size.width,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          FullScreenButton()
        ],
      ),
      builder: (context, player) => player,
    );
  }
}
