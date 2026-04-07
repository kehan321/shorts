import 'package:flutter/material.dart';
import 'package:shorts/core/utils/extensions.dart';

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

  /// Page index that should play (follows scroll position, switches near halfway).
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageScroll);
  }

  void _onPageScroll() {
    if (!_pageController.hasClients || widget.videos.isEmpty) return;
    final p = _pageController.page;
    final n = widget.videos.length;
    final i = p == null ? 0 : p.round().clamp(0, n - 1);
    if (i != _focusedIndex) {
      setState(() => _focusedIndex = i);
    }
  }

  bool _mountPlayer(int index) {
    return (index - _focusedIndex).abs() <= 1;
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageScroll);
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
          allowImplicitScrolling: true,
          onPageChanged: (i) {
            if (i != _focusedIndex) {
              setState(() => _focusedIndex = i);
            }
          },
          itemCount: widget.videos.length,
          itemBuilder: (context, index) {
            final video = widget.videos[index];
            final mount = _mountPlayer(index);
            return SizedBox(
              height: h,
              width: w,
              child: RepaintBoundary(
                child: mount
                    ? FeedVideoPostTile(
                        video: video,
                        isActive: index == _focusedIndex,
                      )
                    : ColoredBox(color: context.theme.colorScheme.onSurface),
              ),
            );
          },
        );
      },
    );
  }
}
