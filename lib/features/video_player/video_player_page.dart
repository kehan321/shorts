import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/constants/status_switcher.dart';
import 'video_player_cubit.dart';
import 'video_player_state.dart';
import 'widgets/video_player_content.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key, required this.cubit});

  final VideoPlayerCubit cubit;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    widget.cubit.navigator.context = context;
  }

  @override
  void dispose() {
    widget.cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder(
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
              );
            },
          );
        },
      ),
    );
  }
}
