import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerCenterOverlay extends StatelessWidget {
  const VideoPlayerCenterOverlay({
    super.key,
    required this.controller,
    required this.chromeVisible,
    required this.onPlayPressed,
  });

  final VideoPlayerController controller;
  final bool chromeVisible;
  final VoidCallback onPlayPressed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        if (value.isPlaying && !chromeVisible) {
          return const SizedBox.shrink();
        }
        if (value.isPlaying) {
          return IgnorePointer(
            child: Center(
              child: Icon(
                Icons.pause_circle_filled_rounded,
                color: Colors.white.withValues(alpha: 0.4),
                size: 64,
              ),
            ),
          );
        }
        return Center(
          child: Material(
            color: Colors.black45,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPlayPressed,
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 56,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
