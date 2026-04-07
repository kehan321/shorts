import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// YouTube-style progress track with a draggable circular thumb; uses [VideoScrubber] for seeking.
class VideoPlayerSeekBar extends StatelessWidget {
  const VideoPlayerSeekBar({
    super.key,
    required this.controller,
    required this.playedColor,
    required this.bufferedColor,
    required this.backgroundColor,
    this.thumbDiameter = 12,
    this.trackHeight = 8,
    this.padding = EdgeInsets.zero,
  });

  final VideoPlayerController controller;
  final Color playedColor;
  final Color bufferedColor;
  final Color backgroundColor;
  final double thumbDiameter;
  final double trackHeight;
  final EdgeInsets padding;

  static const double _hitHeight = 28;

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return SizedBox(
        height: _hitHeight,
        child: Padding(padding: padding, child: const SizedBox.expand()),
      );
    }

    return VideoScrubber(
      controller: controller,
      child: Padding(
        padding: padding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final durationMs = controller.value.duration.inMilliseconds;
            final positionMs = controller.value.position.inMilliseconds;

            var maxBuffered = 0;
            for (final range in controller.value.buffered) {
              final end = range.end.inMilliseconds;
              if (end > maxBuffered) maxBuffered = end;
            }

            final durationSafe = durationMs > 0 ? durationMs : 1;
            final playedFraction = (positionMs / durationSafe).clamp(0.0, 1.0);
            final bufferedFraction = (maxBuffered / durationSafe).clamp(
              0.0,
              1.0,
            );

            final thumbRadius = thumbDiameter / 2;
            final barCenterY = _hitHeight / 2;
            final thumbLeft = w <= thumbDiameter
                ? 0.0
                : (w * playedFraction - thumbRadius).clamp(
                    0.0,
                    w - thumbDiameter,
                  );

            return SizedBox(
              height: _hitHeight,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: barCenterY - trackHeight / 2,
                    height: trackHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(trackHeight / 2),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: barCenterY - trackHeight / 2,
                    width: w * bufferedFraction,
                    height: trackHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: bufferedColor,
                        borderRadius: BorderRadius.circular(trackHeight / 2),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: barCenterY - trackHeight / 2,
                    width: w * playedFraction,
                    height: trackHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: playedColor,
                        borderRadius: BorderRadius.circular(trackHeight / 2),
                      ),
                    ),
                  ),
                  Positioned(
                    left: thumbLeft,
                    top: barCenterY - thumbRadius,
                    width: thumbDiameter,
                    height: thumbDiameter,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
