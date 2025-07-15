import 'package:async_redux/async_redux.dart';

import '../main.dart';

class CustomNavigateAction<St> extends NavigateAction<St> {
  CustomNavigateAction._pushNamed(super.route) : super.pushNamed();

  CustomNavigateAction._pushReplacementNamed(super.route)
    : super.pushReplacementNamed();

  CustomNavigateAction._pop() : super.pop();

  factory CustomNavigateAction.pushNamed(String route) {
    NavigateAction.setNavigatorKey(appRoutes.navigatorKeyGetter(route));
    return CustomNavigateAction._pushNamed(route);
  }

  factory CustomNavigateAction.pushReplacementNamed(String route) {
    NavigateAction.setNavigatorKey(appRoutes.navigatorKeyGetter(route));
    return CustomNavigateAction._pushReplacementNamed(route);
  }

  factory CustomNavigateAction.pop() {
    return CustomNavigateAction._pop();
  }
}
