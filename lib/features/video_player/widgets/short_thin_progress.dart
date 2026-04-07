import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_app/core/utils/extensions.dart';

class ShortsThinProgress extends StatelessWidget {
  const ShortsThinProgress({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return SizedBox(height: 12.h);
    }
    return VideoScrubber(
      controller: controller,
      child: SizedBox(
        height: 18.h,
        width: double.infinity,
        child: ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            final dMs = value.duration.inMilliseconds;
            final pMs = value.position.inMilliseconds;
            var maxBuf = 0;
            for (final r in value.buffered) {
              final e = r.end.inMilliseconds;
              if (e > maxBuf) maxBuf = e;
            }
            final played = dMs > 0 ? (pMs / dMs).clamp(0.0, 1.0) : 0.0;
            final buffered = dMs > 0 ? (maxBuf / dMs).clamp(0.0, 1.0) : 0.0;
            return LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 3.h,
                      width: w,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 3.h,
                        width: w * buffered,
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(1.5.r),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 3.h,
                        width: w * played,
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(1.5.r),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
