import 'package:flutter/material.dart';
import '/features/video_player/video_player_navigator.dart';
import 'login_initial_params.dart';
import 'login_page.dart';
import '/config/navigation/app_navigator.dart';
import '/injection_container.dart';
import '/config/navigation/transition_type.dart';

class LoginNavigator with VideoPlayerRoute{
  LoginNavigator(this.navigator);
  @override
  late BuildContext context;

  @override
  AppNavigator navigator;
}

mixin LoginRoute {
  openLogin(LoginInitialParams initialParams) {
navigator.pushAndRemoveUntil(
        context: context,
        routeName: LoginPage(cubit: getIt(param1: initialParams)),
        transitionType: TransitionType.slideFromLeft,
        predicate: (route) => false);
}

  AppNavigator get navigator;

  BuildContext get context;
}
