import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shorts/core/utils/extensions.dart';
import 'package:shorts/core/widgets/app_bar.dart';
import 'package:shorts/data/datasources/auth/user_data_sources.dart';
import 'package:shorts/data/models/user/user_info_store_model.dart';

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
    return BlocBuilder<UserDataSources, UserInfoStoreModel>(
      bloc: cubit.userDataSources,
      builder: (context, session) {
        final scheme = context.colorScheme;
        return Scaffold(
          appBar: CustomAppBar.getAppBar(
            context: context,
            showLeading: false,
            automaticallyImplyLeading: false,
            title: session.user?.name ?? 'Video',
            foregroundColor: scheme.onSurface,
            quickActions: [
              AppBarAction(
                icon: Icon(Icons.logout_rounded, color: scheme.primary),
                tooltip: 'Log out',
                onPressed: () => cubit.logout(),
              ),
            ],
          ),
          body: BlocBuilder(
            bloc: cubit,
            builder: (context, state) {
              state as VideoPlayerState;
              return StatusSwitcher(
                response: state.response,
                onLoading: (ctx) => Center(
                  child: CircularProgressIndicator(
                    color: context.theme.colorScheme.onPrimary,
                  ),
                ),
                onCompleted: (ctx, data) {
                  final url = cubit.resolvePlaybackUrl(data);
                  return VideoPlayerContent(
                    key: ValueKey(url),
                    videoUrl: url,
                    cubit: cubit,
                    isActive: true,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
