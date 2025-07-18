import 'package:async_redux/async_redux.dart';
import 'package:flutter/animation.dart';
import '../app_routes.dart';
import '../main.dart';

class CustomNavigateAction<St> extends NavigateAction<St> {
  CustomNavigateAction._pushNamed(super.route, {super.arguments})
    : super.pushNamed();

  CustomNavigateAction._pushReplacementNamed(super.route, {super.arguments})
    : super.pushReplacementNamed();

  CustomNavigateAction._pop() : super.pop();

  static Future<void> jumpToPageAndPushNamed(
    String route, {
    PageTransition? pageTransition,
  }) async {
    final scaffold = appRoutes.scaffoldRoutes;
    if (scaffold != null) {
      for (int i = 0; i < scaffold.children.length; i++) {
        final tabPath = scaffold.children[i].path;
        if (route == tabPath || route.startsWith('/$tabPath/')) {
          final navigatorKey = appRoutes.navigatorKeyGetter(tabPath);
          navigatorKey.currentState?.pushNamed(
            route,
            arguments: {'pageTransition': pageTransition},
          );
          await Future.delayed(Duration(milliseconds: 111));
          appRoutes.pageController.animateToPage(
            i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );

          break;
        }
      }
    }
  }

  factory CustomNavigateAction.pushNamed(
    String route, {
    PageTransition? pageTransition,
  }) {
    NavigateAction.setNavigatorKey(appRoutes.navigatorKeyGetter(route));
    return CustomNavigateAction._pushNamed(
      route,
      arguments: {"pageTransition": pageTransition},
    );
  }

  factory CustomNavigateAction.pushReplacementNamed(String route) {
    NavigateAction.setNavigatorKey(appRoutes.navigatorKeyGetter(route));
    return CustomNavigateAction._pushReplacementNamed(route);
  }

  factory CustomNavigateAction.pop() {
    return CustomNavigateAction._pop();
  }
}
