import 'package:flutter/material.dart';

class RouteConfig {
  final String path;
  final Widget child;
  final IconData? icon;
  final List<RouteConfig> children;

  const RouteConfig({
    required this.path,
    required this.child,
    this.icon,
    this.children = const [],
  });
}

class RouteService {
  final List<RouteConfig> securedRoutes;
  final List<RouteConfig> unsecuredRoutes;
  final String initialSecuredRoute;
  final String initialUnsecuredRoute;
  final bool loggedIn;

  RouteService({
    required this.securedRoutes,
    required this.unsecuredRoutes,
    required this.loggedIn,
    String? initialSecuredRoute,
    String? initialUnsecuredRoute,
  }) : initialSecuredRoute = securedRoutes.first.path,
       initialUnsecuredRoute = unsecuredRoutes.first.path;

  String get initialRoute =>
      loggedIn ? initialSecuredRoute : initialUnsecuredRoute;

  List<RouteConfig> get routes {
    if (loggedIn) {
      return securedRoutes;
    } else {
      return unsecuredRoutes;
    }
  }

  List<RouteConfig> resolveWidgetStack(List<String> pageStack) {
    List<RouteConfig> newRoutes =
        routes.map((r) {
          if (r.path == "/") {
            return RouteConfig(
              path: "root",
              child: r.child,
              children: r.children,
            );
          }
          return r;
        }).toList();

    final nested = _resolveWidgetStackRecursive(pageStack, newRoutes);
    return [...nested];
  }

  static List<RouteConfig> _resolveWidgetStackRecursive(
    List<String> segments,
    List<RouteConfig> configs,
  ) {
    final head = segments.first;
    for (final config in configs) {
      if (config.path == head) {
        final RouteConfig current = config;
        if (segments.length == 1) return [current];
        final rest = _resolveWidgetStackRecursive(
          segments.sublist(1),
          config.children,
        );
        return [current, ...rest];
      }
    }
    return []; // fallback
  }
}
