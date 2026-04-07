import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../video_player_cubit.dart';
import '../video_player_state.dart';
import 'short_chrome_layer.dart';
import 'short_thin_progress.dart';
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
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
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
            ShortsChromeLayer(
              visible: true,
              params: widget.cubit.initialParams,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: ShortsThinProgress(controller: controller),
              ),
            ),
          ],
        );
      },
    );
  }
}
