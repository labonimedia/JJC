import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPreviewScreen extends StatefulWidget {
  final String? url;
  VideoPreviewScreen({super.key, this.url});

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    // Extract Video ID from URL
    String? videoId = YoutubePlayer.convertUrlToId(widget.url ?? "");

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? "",
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true, // Force HD playback
        enableCaption: true,
      ),
    );

    // Listen for Fullscreen Toggle
    _controller!.addListener(() {
      if (_controller!.value.isFullScreen) {
        _setLandscapeMode(); // Set landscape mode when full-screen
      } else {
        _setPortraitMode(); // Reset to portrait when exiting full-screen
      }
    });
  }

  @override
  void dispose() {
    _setPortraitMode(); // Ensure portrait mode when exiting the screen
    _controller!.dispose();
    super.dispose();
  }

  // Set Landscape Mode
  void _setLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // Set Portrait Mode
  void _setPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
        onReady: () {
          _controller!.play();
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: BackButton(
              onPressed: () {
                _setPortraitMode(); // Reset to portrait when exiting
                Get.back();
              },
              color: Colors.black,
            ),
          ),
          body: Center(
            child: AspectRatio(
              aspectRatio: MediaQuery.of(context).size.aspectRatio > 1 ? 16 / 9 : 9 / 16,
              child: player,
            ),
          ),
        );
      },
    );
  }
}
