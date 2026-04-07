import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'video_player_constants.dart';
import 'video_player_seek_bar.dart';

String _formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  if (h > 0) {
    return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
  return '${m.toString()}:${s.toString().padLeft(2, '0')}';
}

String _speedLabel(double s) {
  if ((s * 100).round() % 100 == 0) return '${s.round()}x';
  return '${s}x';
}

bool _speedEquals(double a, double b) => (a - b).abs() < 0.001;

class VideoPlayerBottomChrome extends StatelessWidget {
  const VideoPlayerBottomChrome({
    super.key,
    required this.controller,
    required this.onSeekBack,
    required this.onSeekForward,
    required this.onTogglePlay,
    required this.onSpeedSelected,
  });

  final VideoPlayerController controller;
  final VoidCallback onSeekBack;
  final VoidCallback onSeekForward;
  final VoidCallback onTogglePlay;
  final ValueChanged<double> onSpeedSelected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  _formatDuration(value.position),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const Spacer(),
                Text(
                  _formatDuration(value.duration),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            VideoPlayerSeekBar(
              controller: controller,
              playedColor: const Color(0xFFE53935),
              bufferedColor: Colors.white24,
              backgroundColor: Colors.white12,
              thumbDiameter: 14,
              trackHeight: 3,
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: onSeekBack,
                  icon: const Icon(Icons.replay_10_rounded),
                  color: Colors.white,
                  iconSize: 36,
                  tooltip: 'Back 10 seconds',
                ),
                IconButton(
                  onPressed: onTogglePlay,
                  icon: Icon(
                    value.isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_filled_rounded,
                  ),
                  color: Colors.white,
                  iconSize: 52,
                  tooltip: value.isPlaying ? 'Pause' : 'Play',
                ),
                IconButton(
                  onPressed: onSeekForward,
                  icon: const Icon(Icons.forward_10_rounded),
                  color: Colors.white,
                  iconSize: 36,
                  tooltip: 'Forward 10 seconds',
                ),
                PopupMenuButton<double>(
                  tooltip: 'Playback speed',
                  color: const Color(0xFF2C2C2C),
                  onSelected: onSpeedSelected,
                  itemBuilder: (context) => VideoPlayerConstants.playbackSpeeds
                      .map(
                        (speed) => PopupMenuItem<double>(
                          value: speed,
                          child: Row(
                            children: [
                              if (_speedEquals(speed, value.playbackSpeed))
                                const Icon(
                                  Icons.check,
                                  color: Colors.white70,
                                  size: 18,
                                )
                              else
                                const SizedBox(width: 18),
                              const SizedBox(width: 8),
                              Text(
                                _speedLabel(speed),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.speed_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        Text(
                          '${value.playbackSpeed}x',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
