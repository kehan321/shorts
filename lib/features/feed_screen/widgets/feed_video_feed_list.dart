import 'package:flutter/material.dart';

import 'feed_video_post_tile.dart';

class FeedVideoFeedList extends StatefulWidget {
  const FeedVideoFeedList({super.key, required this.urls});

  final List<String> urls;
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
          itemCount: widget.urls.length,
          itemBuilder: (context, index) {
            final showPlayer = index == _currentPage;
            return SizedBox(
              height: h,
              width: w,
              child: RepaintBoundary(
                child: showPlayer
                    ? FeedVideoPostTile(videoUrl: widget.urls[index])
                    : const ColoredBox(color: Colors.black),
              ),
            );
          },
        );
      },
    );
  }
}
