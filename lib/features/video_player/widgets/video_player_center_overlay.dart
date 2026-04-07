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
                Icons.pause_rounded,
                color: Colors.white.withValues(alpha: 0.88),
                size: 64,
              ),
            ),
          );
        }
        return Center(
          child: GestureDetector(
            onTap: onPlayPressed,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.95),
                  width: 2.5,
                ),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 54,
              ),
            ),
          ),
        );
      },
    );
  }
}
