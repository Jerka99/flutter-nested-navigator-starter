import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';

class CustomNavigateAction<St> extends NavigateAction<St> {
  CustomNavigateAction._pushNamed(super.route) : super.pushNamed();

  CustomNavigateAction._pushReplacementNamed(super.route)
    : super.pushReplacementNamed();

  CustomNavigateAction._pop() : super.pop();



  factory CustomNavigateAction.pushNamed(
    String route,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    NavigateAction.setNavigatorKey(navigatorKey);
    return CustomNavigateAction._pushNamed(route);
  }

  factory CustomNavigateAction.pushReplacementNamed(
    String route,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    NavigateAction.setNavigatorKey(navigatorKey);
    return CustomNavigateAction._pushReplacementNamed(route);
  }

  factory CustomNavigateAction.pop() {
    return CustomNavigateAction._pop();
  }
}
