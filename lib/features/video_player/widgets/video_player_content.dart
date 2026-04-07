import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../video_player_cubit.dart';
import '../video_player_state.dart';
import 'video_player_bottom_chrome.dart';
import 'video_player_center_overlay.dart';
import 'video_player_constants.dart';

class VideoPlayerContent extends StatefulWidget {
  const VideoPlayerContent({
    super.key,
    required this.videoUrl,
    required this.cubit,
  });

  final String videoUrl;
  final VideoPlayerCubit cubit;

  @override
  State<VideoPlayerContent> createState() => _VideoPlayerContentState();
}

class _VideoPlayerContentState extends State<VideoPlayerContent> {
  VideoPlayerController? _controller;
  Timer? _hideChromeTimer;
  String? _initError;

  VideoPlayerCubit get _cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    // Defer decode/platform setup until after first frame (helps feed cold start).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initController();
    });
  }

  @override
  void didUpdateWidget(covariant VideoPlayerContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeController();
      _initController();
    }
  }

  @override
  void dispose() {
    _cancelHideChromeTimer();
    _disposeController();
    super.dispose();
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  Future<void> _initController() async {
    setState(() => _initError = null);
    final source = widget.videoUrl.trim();
    if (source.isEmpty) {
      if (!mounted) return;
      setState(() => _initError = 'Empty video URL');
      return;
    }
    VideoPlayerController? controller;
    try {
      controller = VideoPlayerController.networkUrl(
        Uri.parse(source),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await controller.initialize();
    } catch (e, _) {
      await controller?.dispose();
      if (!mounted) return;
      setState(() => _initError = e.toString());
      return;
    }
    final c = controller;
    if (!mounted) {
      c.dispose();
      return;
    }
    setState(() => _controller = c);
    _cubit.setChromeVisible(true);
    await c.setLooping(false);
    await c.play();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scheduleHideChrome();
    });
  }

  void _cancelHideChromeTimer() {
    _hideChromeTimer?.cancel();
    _hideChromeTimer = null;
  }

  void _scheduleHideChrome() {
    _cancelHideChromeTimer();
    _hideChromeTimer = Timer(VideoPlayerConstants.hideChromeAfter, () {
      if (!mounted) return;
      final c = _controller;
      if (c != null && c.value.isPlaying) {
        _cubit.setChromeVisible(false);
      }
    });
  }

  void _deferHideChromeAfterChromePointerUp() {
    const delays = <int>[50, 120, 120, 120, 120, 120];
    var i = 0;
    void step() {
      if (!mounted) return;
      if (i >= delays.length) return;
      final wait = delays[i];
      i++;
      Future<void>.delayed(Duration(milliseconds: wait), () {
        if (!mounted) return;
        final c = _controller;
        if (c != null && c.value.isPlaying) {
          _scheduleHideChrome();
          return;
        }
        step();
      });
    }

    step();
  }

  void _onVideoSurfaceTap() {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;

    if (c.value.isPlaying) {
      if (_cubit.state.chromeVisible) {
        _cancelHideChromeTimer();
        c.pause();
        _cubit.setChromeVisible(true);
      } else {
        _cubit.setChromeVisible(true);
        _scheduleHideChrome();
      }
    } else {
      c.play();
      _cubit.setChromeVisible(true);
      _scheduleHideChrome();
    }
  }

  void _togglePlayFromChrome() {
    final c = _controller;
    if (c == null) return;
    if (c.value.isPlaying) {
      _cancelHideChromeTimer();
      c.pause();
      _cubit.setChromeVisible(true);
    } else {
      c.play();
      _cubit.setChromeVisible(true);
      _scheduleHideChrome();
    }
  }

  void _seekRelative(Duration offset) {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    final wasPlaying = c.value.isPlaying;
    final totalMs = c.value.duration.inMilliseconds;
    final nextMs = (c.value.position + offset).inMilliseconds.clamp(0, totalMs);
    c.seekTo(Duration(milliseconds: nextMs));
    _cubit.setChromeVisible(true);
    if (wasPlaying) {
      _scheduleHideChrome();
    }
  }

  Future<void> _setSpeed(double speed) async {
    final c = _controller;
    if (c == null) return;
    await c.setPlaybackSpeed(speed);
    if (c.value.isPlaying) {
      _cubit.setChromeVisible(true);
      _scheduleHideChrome();
    }
  }

  void _onCenterPlayPressed() {
    _controller?.play();
    _cubit.setChromeVisible(true);
    _scheduleHideChrome();
  }

  @override
  Widget build(BuildContext context) {
    final err = _initError;
    if (err != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Could not load video.\n$err',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocBuilder(
      bloc: widget.cubit,
      builder: (context, state) {
        state as VideoPlayerState;
        final chromeVisible = state.chromeVisible;
        return Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _onVideoSurfaceTap,
              ),
            ),
            VideoPlayerCenterOverlay(
              controller: controller,
              chromeVisible: chromeVisible,
              onPlayPressed: _onCenterPlayPressed,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSlide(
                duration: VideoPlayerConstants.chromeSlideDuration,
                curve: Curves.easeInOutCubic,
                offset: chromeVisible ? Offset.zero : const Offset(0, 1),
                child: IgnorePointer(
                  ignoring: !chromeVisible,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.92),
                          Colors.black.withValues(alpha: 0.6),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Listener(
                        behavior: HitTestBehavior.deferToChild,
                        onPointerDown: (_) => _cancelHideChromeTimer(),
                        onPointerUp: (_) =>
                            _deferHideChromeAfterChromePointerUp(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 28, 12, 10),
                          child: VideoPlayerBottomChrome(
                            controller: controller,
                            onSeekBack: () =>
                                _seekRelative(-VideoPlayerConstants.skipStep),
                            onSeekForward: () =>
                                _seekRelative(VideoPlayerConstants.skipStep),
                            onTogglePlay: _togglePlayFromChrome,
                            onSpeedSelected: _setSpeed,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
