// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final bool isPlayingState;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    required this.isPlayingState,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  late bool isPlaying;

  @override
  void initState() {
    super.initState();
    isPlaying = widget.isPlayingState;
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Stack(
        children: [
          VideoPlayer(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (isPlaying) {
                  videoPlayerController.pause();
                } else {
                  videoPlayerController.play();
                }

                setState(() {
                  isPlaying = !isPlaying;
                });
              },
              icon: Icon(
                size: 45,
                isPlaying ? Icons.pause_circle : Icons.play_circle,
              ),
            ),
          ),
        ],
      ),
    );

    // return Container(
    //   width: size.width,
    //   height: size.height,
    //   decoration: const BoxDecoration(
    //     color: Colors.black,
    //   ),
    //   child: VideoPlayer(videoPlayerController),
    // );
  }
}
