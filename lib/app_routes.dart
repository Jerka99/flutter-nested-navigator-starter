import 'package:flutter/material.dart';
import 'package:untitled/pages/details_page.dart';
import 'package:untitled/pages/first_page.dart';
import 'package:untitled/scaffold_with_nested_navigators.dart';
import 'async_redux/connectors/login_page_connector.dart';
import 'async_redux/connectors/page_2_connector.dart';
import 'async_redux/connectors/profile_connector.dart';

class AppRoutes {

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final List<GlobalKey<NavigatorState>> nestedNavigatorKeys =
      List.generate(scaffoldRoutes.length, (_) => GlobalKey<NavigatorState>());

  static final Set<RouteConfig> scaffoldRoutes = <RouteConfig>{
    RouteConfig(path: '/home', builder: (_) => FirstPage(), icon: Icons.home),
    RouteConfig(
      path: '/settings',
      builder: (_) => SettingsPageConnector(),
      icon: Icons.settings,
    ),
    RouteConfig(
      path: '/profile',
      builder: (_) => ProfileWidgetConnector(),
      icon: Icons.person,
      children: [
        RouteConfig(path: '/profile/details', builder: (_) => DetailsPage()),
      ],
    ),
  };

  static final Set<RouteConfig> rootRoutes = <RouteConfig>{
    RouteConfig(path: '/login', builder: (_) => LoginPageConnector()),
    RouteConfig(
      path: '/page2',
      builder:
          (_) => ScaffoldWithNestedNavigators(
            mainRoutes: scaffoldRoutes.toList(),
            navigatorKeys: nestedNavigatorKeys,
          ),
    ),
  };

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
