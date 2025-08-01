// import 'package:async_redux/async_redux.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:my_flutter_library/app_routes.dart';
//
// import '../main.dart';
//
// class CustomNavigateAction<St> extends NavigateAction<St> {
//   CustomNavigateAction._pushNamed(super.route, {super.arguments})
//     : super.pushNamed();
//
//   CustomNavigateAction._pushReplacementNamed(super.route, {super.arguments})
//     : super.pushReplacementNamed();
//
//   CustomNavigateAction._replaceRouteBelow(Route? anchorRoute, Route? newRoute)
//     : super.replaceRouteBelow(anchorRoute: anchorRoute, newRoute: newRoute);
//
//   CustomNavigateAction._pop() : super.pop();
//
//   static Future<void> jumpToPageAndPushNamed(
//     String route, {
//     PageTransition? pageTransition,
//   }) async {
//     final scaffold = AppRoutes.instance.scaffoldRoutes;
//     if (scaffold != null) {
//       for (int i = 0; i < scaffold.children.length; i++) {
//         final tabPath = scaffold.children[0].path;
//         if (route == tabPath || route.startsWith('/$tabPath/')) {
//           final navigatorKey = AppRoutes.instance.navigatorKeyGetter(tabPath);
//           // AppRoutes.instance.rootNavigatorKey.currentState?.pushReplacementNamed(
//           //   "main",
//           // );
//           AppRoutes.instance.pageController.jumpToPage(i);
//           // await Future.delayed(Duration(milliseconds: 10));
//           // AppRoutes.instance.nestedNavigatorKeys[0].currentState?.pushNamed(
//           //   "/home/details",
//           // );
//
//           // print(myRouteObserver.currentRoute);
//           // AppRoutes.instance.nestedNavigatorKeys[0].currentState?.pushNamed(
//           //   "/home/details",
//           //   arguments: {'pageTransition': pageTransition},
//           // );
//
//           break;
//         }
//       }
//     }
//   }
//
//   factory CustomNavigateAction.pushNamed(
//     String route, {
//     PageTransition? pageTransition,
//   }) {
//     NavigateAction.setNavigatorKey(
//       AppRoutes.instance.navigatorKeyGetter(route),
//     );
//     return CustomNavigateAction._pushNamed(
//       route,
//       arguments: {"pageTransition": pageTransition},
//     );
//   }
//
//   factory CustomNavigateAction.pushReplacementNamed(String route) {
//     NavigateAction.setNavigatorKey(
//       AppRoutes.instance.navigatorKeyGetter(route),
//     );
//     return CustomNavigateAction._pushReplacementNamed(route);
//   }
//
//   // factory CustomNavigateAction.replaceRouteBelow(String route) {
//   //   NavigateAction.setNavigatorKey(
//   //     AppRoutes.instance.navigatorKeyGetter(route),
//   //   );
//   //   return CustomNavigateAction._replaceRouteBelow(route);
//   // }
//
//   factory CustomNavigateAction.pop() {
//     return CustomNavigateAction._pop();
//   }
// }
