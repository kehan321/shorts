import 'package:flutter/material.dart';

import '/config/navigation/app_navigator.dart';
import '/injection_container.dart';
import 'feed_screen_initial_params.dart';
import 'feed_screen_page.dart';

class FeedScreenNavigator {
  FeedScreenNavigator(this.navigator);
  @override
  late BuildContext context;
  @override
  AppNavigator navigator;
}

mixin FeedScreenRoute {
  void openFeedScreen(FeedScreenInitialParams initialParams) {
    navigator.push(
      context: context,
      routeName: FeedScreenPage(cubit: getIt(param1: initialParams)),
    );
  }

  AppNavigator get navigator;

  BuildContext get context;
}
