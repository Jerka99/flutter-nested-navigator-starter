import 'package:async_redux/async_redux.dart';
import '../main.dart';

class CustomNavigateAction<St> extends NavigateAction<St> {
  CustomNavigateAction._pushNamed(String route, {Object? arguments})
      : super.pushNamed(route, arguments: arguments);

  CustomNavigateAction._pushReplacementNamed(super.route)
    : super.pushReplacementNamed();

  CustomNavigateAction._pop() : super.pop();

  static Future<void> jumpToPageAndPushNamed(String route) async {
    final scaffold = appRoutes.scaffoldRoutes;
    if (scaffold != null) {
      for (int i = 0; i < scaffold.children.length; i++) {
        final tabPath = scaffold.children[i].path;
        if (route == tabPath || route.startsWith('/$tabPath/')) {
          appRoutes.pageController.jumpToPage(i);
          final navigatorKey = appRoutes.navigatorKeyGetter(tabPath);
          NavigateAction.setNavigatorKey(navigatorKey);

            await Future.delayed(Duration(milliseconds: 20));
            navigatorKey.currentState?.pushNamed(route);

          break;
        }
      }
    }
  }

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
