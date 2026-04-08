import 'package:flutter/material.dart';
import 'package:shorts/features/feed_screen/feed_screen_navigator.dart';

import '/config/navigation/app_navigator.dart';
import '/features/auth/login/login_navigator.dart';
import '/features/splash/splash_page.dart';
import '/injection_container.dart';
import 'splash_initial_params.dart';

class SplashNavigator with FeedScreenRoute, LoginRoute {
  SplashNavigator(this.navigator);
  @override
  late BuildContext context;

  @override
  AppNavigator navigator;
}

mixin SplashRoute {
  void openLogin(SplashInitialParams initialParams) {
    navigator.push(
      context: context,
      routeName: SplashPage(cubit: getIt(param1: initialParams)),
    );
  }

  AppNavigator get navigator;

  BuildContext get context;
}
