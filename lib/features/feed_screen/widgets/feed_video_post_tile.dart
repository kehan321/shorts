import 'package:flutter/material.dart';
import 'package:video_player_app/core/utils/extensions.dart';

import '/data/models/feed/feed_model.dart';
import '/features/video_player/video_player_cubit.dart';
import '/features/video_player/video_player_initial_params.dart';
import '/features/video_player/widgets/video_player_view.dart';
import '/injection_container.dart';

class FeedVideoPostTile extends StatefulWidget {
  const FeedVideoPostTile({
    super.key,
    required this.video,
    required this.isActive,
  });

  final Video video;
  final bool isActive;

  @override
  State<FeedVideoPostTile> createState() => _FeedVideoPostTileState();
}

class _FeedVideoPostTileState extends State<FeedVideoPostTile> {
  late VideoPlayerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = _createCubit(widget.video);
    _cubit.navigator.context = context;
  }

  VideoPlayerCubit _createCubit(Video video) {
    final url = video.playbackUrl ?? '';
    return getIt<VideoPlayerCubit>(
      param1: VideoPlayerInitialParams(
        videoUrl: url.isEmpty ? null : url,
        channelHandle: video.shortsChannelLabel,
        caption: video.shortsCaption,
        thumbnailUrl: video.shortsThumbnailUrl,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant FeedVideoPostTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.id != widget.video.id) {
      _cubit.close();
      _cubit = _createCubit(widget.video);
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
    final url = widget.video.playbackUrl;
    if (url == null || url.isEmpty) {
      return Center(
        child: Text(
          'No playable stream',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.theme.colorScheme.onPrimary.withValues(alpha: 0.54),
          ),
        ),
      );
    }
    return ColoredBox(
      color: context.theme.colorScheme.onSurface,
      child: SizedBox.expand(
        child: VideoPlayerView(cubit: _cubit, isActive: widget.isActive),
      ),
    );
  }
}
