import 'package:flutter/material.dart';
import 'fetching_initial_params.dart';
import 'fetching_page.dart';
import '/config/navigation/app_navigator.dart';
import '/injection_container.dart';

class FetchingNavigator {
  FetchingNavigator(this.navigator);
  @override
  late BuildContext context;
  @override
  AppNavigator navigator;
}

mixin FetchingRoute {
openFetching(FetchingInitialParams initialParams) {
navigator.push(
context: context,
        routeName: FetchingPage(cubit: getIt(param1: initialParams))
);
}

AppNavigator get navigator;

BuildContext get context;
}
