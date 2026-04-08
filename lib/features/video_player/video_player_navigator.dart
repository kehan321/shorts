import 'package:flutter/material.dart';

import '/config/navigation/app_navigator.dart';
import '/features/auth/login/login_navigator.dart';
import '/injection_container.dart';
import 'video_player_initial_params.dart';
import 'video_player_page.dart';

class VideoPlayerNavigator with VideoPlayerRoute, LoginRoute {
  VideoPlayerNavigator(this.navigator);

  @override
  late BuildContext context;

  @override
  AppNavigator navigator;
}

mixin VideoPlayerRoute {
  void openVideoPlayer(VideoPlayerInitialParams initialParams) {
    navigator.push(
      context: context,
      routeName: VideoPlayerPage(cubit: getIt(param1: initialParams)),
    );
  }

  AppNavigator get navigator;

  BuildContext get context;
}
