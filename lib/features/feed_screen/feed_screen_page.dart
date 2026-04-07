import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shorts/data/models/feed/feed_model.dart';

import '/core/constants/status_switcher.dart';
import 'feed_screen_cubit.dart';
import 'feed_screen_state.dart';
import 'widgets/feed_video_feed_list.dart';

class FeedScreenPage extends StatefulWidget {
  const FeedScreenPage({super.key, required this.cubit});

  final FeedScreenCubit cubit;

  @override
  State<FeedScreenPage> createState() => _FeedScreenPageState();
}

class _FeedScreenPageState extends State<FeedScreenPage> {
  FeedScreenCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.feedScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator.adaptive(
            onRefresh: cubit.feedScreen,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: BlocBuilder(
                  bloc: cubit,
                  builder: (context, state) {
                    state as FeedScreenState;
                    return StatusSwitcher(
                      response: state.response,
                      onLoading: (context) =>
                          const Center(child: Text("Loading...")),
                      onRetry: () => cubit.feedScreen(),
                      onCompleted: (context, feed) {
                        return FeedVideoFeedList(videos: feed.playableVideos);
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
