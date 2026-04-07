import 'package:flutter/material.dart';

import '/features/video_player/video_player_cubit.dart';
import '/features/video_player/video_player_initial_params.dart';
import '/features/video_player/widgets/video_player_view.dart';
import '/injection_container.dart';

class FeedVideoPostTile extends StatefulWidget {
  const FeedVideoPostTile({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<FeedVideoPostTile> createState() => _FeedVideoPostTileState();
}

class _FeedVideoPostTileState extends State<FeedVideoPostTile> {
  late VideoPlayerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<VideoPlayerCubit>(
      param1: VideoPlayerInitialParams(videoUrl: widget.videoUrl),
    );
    _cubit.navigator.context = context;
  }

  @override
  void didUpdateWidget(covariant FeedVideoPostTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _cubit.close();
      _cubit = getIt<VideoPlayerCubit>(
        param1: VideoPlayerInitialParams(videoUrl: widget.videoUrl),
      );
      _cubit.navigator.context = context;
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: SizedBox.expand(
        child: VideoPlayerView(cubit: _cubit),
      ),
    );
  }
}
