import 'package:flutter/material.dart';
import 'package:untitled/scaffold_with_nested_navigators.dart';

class AppRoutes {
  final List<dynamic> _userRootRoutes;
  final GlobalKey<NavigatorState> rootNavigatorKey;
  late final List<GlobalKey<NavigatorState>> nestedNavigatorKeys;

  AppRoutes({required List<dynamic> rootRoutes, required this.rootNavigatorKey})
    : _userRootRoutes = rootRoutes {
    final tabCount = scaffoldRoutes?.children.length ?? 0;
    nestedNavigatorKeys = List.generate(
      tabCount,
      (_) => GlobalKey<NavigatorState>(),
    );
  }

  ScaffoldRouteConfig? get scaffoldRoutes {
    final scaffold =
        _userRootRoutes.whereType<ScaffoldRouteConfig>().firstOrNull;
    return scaffold;
  }

  List<RouteConfig> get rootRoutes {
    final routes = _userRootRoutes.whereType<RouteConfig>().toList();

    routes.add(
      RouteConfig(
        path: '/main',
        builder:
            (_) => ScaffoldWithNestedNavigators(
              mainRoutes: scaffoldRoutes?.children,
              navigatorKeys: nestedNavigatorKeys,
            ),
      ),
    );

    return routes;
  }

  GlobalKey<NavigatorState> Function(String route) get navigatorKeyGetter {
    return (String route) {
      for (int i = 0; i < scaffoldRoutes!.children.length; i++) {
        final tabPath = scaffoldRoutes?.children[i].path;
        final key = nestedNavigatorKeys[i];

        if (route == tabPath || route.startsWith('$tabPath/')) {
          return key;
        }
      }

      return rootNavigatorKey;
    };
  }

  static RouteConfig? findRoute(String? name, Set<RouteConfig> configs) {
    for (final config in configs) {
      if (config.path == name) return config;
      final match = findRoute(name, config.children.toSet());
      if (match != null) return match;
    }
    return null;
  }

  static Route<dynamic> generateRoutes(
    RouteSettings settings,
    Set<RouteConfig> routes,
  ) {
    final routeConfig = findRoute(settings.name, routes);
    if (routeConfig?.builder != null) {
      return MaterialPageRoute(
        builder: (context) => routeConfig!.builder(context),
        settings: settings,
      );
    }
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            backgroundColor: Colors.yellow,
            body: const Center(child: Text('Unknown Page')),
          ),
      settings: settings,
    );
  }
}

class RouteConfig {
  final String path;
  final WidgetBuilder builder;
  final IconData? icon;
  final List<RouteConfig> children;

  const RouteConfig({
    required this.path,
    required this.builder,
    this.icon,
    this.children = const [],
  });

  bool get isMainRoute => icon != null;
}

class ScaffoldRouteConfig {
  final List<RouteConfig> children;
  final Widget? bottomNavigationBar;

  const ScaffoldRouteConfig({
    this.children = const [],
    this.bottomNavigationBar,
  });
}
