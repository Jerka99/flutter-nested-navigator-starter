import 'package:flutter/material.dart';
import 'package:untitled/pages/first_page.dart';

import '../async_redux/connectors/details_page_connector.dart';
import '../async_redux/connectors/login_page_connector.dart';
import '../async_redux/connectors/profile_connector.dart';

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

class AppRoutes {
  static String initialRoute = "login";

  static final List<RouteConfig> securedRoutes = [
    RouteConfig(
      path: "home",
      child: FirstPage(),
      icon: Icons.home,
      children: [
        RouteConfig(
          path: 'details',
          child: DetailsPageConnector(),
          children: [
            RouteConfig(path: 'about', child: ProfileWidgetConnector()),
          ],
        ),
      ],
    ),
    RouteConfig(
      path: "nothing",
      child: ProfileWidgetConnector(),
      icon: Icons.person,
      children: [RouteConfig(path: 'details', child: DetailsPageConnector())],
    ),
  ];
  static final List<RouteConfig> unsecuredRoutes = [
    RouteConfig(
      path: initialRoute,
      child: LoginPageConnector(),
      children: [
        RouteConfig(
          path: "profile",
          child: ProfileWidgetConnector(),
          icon: Icons.person,
          children: [
            RouteConfig(
              path: 'details',
              child: DetailsPageConnector(),
              children: [
                RouteConfig(
                  path: ':id',
                  child: Scaffold(body: Container(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];

  static List<RouteConfig> get routes => [...securedRoutes, ...unsecuredRoutes];

  static Widget? resolveWidget(String fullPath) {
    final segments = fullPath.split('/').where((s) => s.isNotEmpty).toList();
    return _resolveRecursive(segments.isEmpty ? ["/"] : segments, routes);
  }

  static Widget? _resolveRecursive(
    List<String> segments,
    List<RouteConfig> configs,
  ) {
    if (segments.isEmpty) return null;
    final head = segments.first;
    for (final config in configs) {
      if (config.path == head) {
        if (segments.length == 1) return config.child;
        return _resolveRecursive(segments.sublist(1), config.children);
      }
    }
    return null;
  }

  static List<RouteConfig> resolveWidgetStack(
    List<String> pageStack,
    String initialRoute,
  ) {
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
