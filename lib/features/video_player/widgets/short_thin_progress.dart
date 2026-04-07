import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShortsThinProgress extends StatelessWidget {
  const ShortsThinProgress({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(height: 12);
    }
    return VideoScrubber(
      controller: controller,
      child: SizedBox(
        height: 18,
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
                      height: 3,
                      width: w,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 3,
                        width: w * buffered,
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 3,
                        width: w * played,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.5),
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
