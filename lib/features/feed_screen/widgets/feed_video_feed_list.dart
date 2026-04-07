import 'package:flutter/material.dart';
import 'package:video_player_app/core/utils/extensions.dart';

import '/data/models/feed/feed_model.dart';
import 'feed_video_post_tile.dart';

class FeedVideoFeedList extends StatefulWidget {
  const FeedVideoFeedList({super.key, required this.videos});

  final List<Video> videos;

  @override
  State<FeedVideoFeedList> createState() => _FeedVideoFeedListState();
}

class _FeedVideoFeedListState extends State<FeedVideoFeedList> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mq = MediaQuery.sizeOf(context);
        final h = constraints.maxHeight.isFinite && constraints.maxHeight > 0
            ? constraints.maxHeight
            : mq.height;
        final w = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : mq.width;

        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          allowImplicitScrolling: false,
          onPageChanged: (i) => setState(() => _currentPage = i),
          itemCount: widget.videos.length,
          itemBuilder: (context, index) {
            final showPlayer = index == _currentPage;
            final video = widget.videos[index];
            return SizedBox(
              height: h,
              width: w,
              child: RepaintBoundary(
                child: showPlayer
                    ? FeedVideoPostTile(video: video)
                    : ColoredBox(color: context.theme.colorScheme.onSurface),
              ),
            );
          },
        );
      },
    );
  }
}
