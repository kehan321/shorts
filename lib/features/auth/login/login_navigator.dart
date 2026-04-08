import 'package:flutter/material.dart';
import 'package:shorts/features/feed_screen/feed_screen_navigator.dart';

import '/config/navigation/app_navigator.dart';
import '/config/navigation/transition_type.dart';
import '/features/video_player/video_player_navigator.dart';
import '/injection_container.dart';
import 'login_initial_params.dart';
import 'login_page.dart';

class LoginNavigator with VideoPlayerRoute, FeedScreenRoute {
  LoginNavigator(this.navigator);
  @override
  late BuildContext context;

  @override
  AppNavigator navigator;
}

mixin LoginRoute {
  void openLogin(LoginInitialParams initialParams) {
    navigator.pushAndRemoveUntil(
      context: context,
      routeName: LoginPage(cubit: getIt(param1: initialParams)),
      transitionType: TransitionType.slideFromLeft,
      predicate: (route) => false,
    );
  }

  AppNavigator get navigator;

  BuildContext get context;
}
