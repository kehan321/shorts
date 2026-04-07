import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/constants/status_switcher.dart';
import '../video_player_cubit.dart';
import '../video_player_state.dart';
import 'video_player_content.dart';

class VideoPlayerView extends StatelessWidget {
  const VideoPlayerView({super.key, required this.cubit, this.isActive = true});

  final VideoPlayerCubit cubit;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
        state as VideoPlayerState;
        return StatusSwitcher(
          response: state.response,
          onLoading: (ctx) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          onCompleted: (ctx, data) {
            final url = cubit.resolvePlaybackUrl(data);
            return VideoPlayerContent(
              key: ValueKey(url),
              videoUrl: url,
              cubit: cubit,
              isActive: isActive,
            );
          },
        );
      },
    );
  }
}
