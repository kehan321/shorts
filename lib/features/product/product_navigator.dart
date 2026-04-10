import 'package:flutter/material.dart';
import 'product_initial_params.dart';
import 'product_page.dart';
import '/config/navigation/app_navigator.dart';
import '/injection_container.dart';

class ProductNavigator {
  ProductNavigator(this.navigator);
  @override
  late BuildContext context;
  @override
  AppNavigator navigator;
}

mixin ProductRoute {
openProduct(ProductInitialParams initialParams) {
navigator.push(
context: context,
        routeName: ProductPage(cubit: getIt(param1: initialParams))
);
}

AppNavigator get navigator;

BuildContext get context;
}
