import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_app/core/utils/extensions.dart';

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
                color: context.theme.colorScheme.onPrimary.withValues(
                  alpha: 0.88,
                ),
                size: 64.r,
              ),
            ),
          );
        }
        return Center(
          child: GestureDetector(
            onTap: onPlayPressed,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 86.r,
              height: 86.r,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.onSurface.withValues(
                  alpha: 0.4,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.95),
                  width: 2.5.r,
                ),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 54.r,
              ),
            ),
          ),
        );
      },
    );
  }
}
