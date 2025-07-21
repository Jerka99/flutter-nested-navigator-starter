import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/scaffold_with_nested_navigators.dart';
import 'package:untitled/transitions_and_scroll_phisics/custom_page_transition_builder.dart';

typedef RoutePageBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    );

class AppRoutes {
  final GlobalKey<NavigatorState> rootNavigatorKey;
  late final List<GlobalKey<NavigatorState>> nestedNavigatorKeys;
  final List<dynamic> _userRootRoutes;

  AppRoutes({required List<dynamic> rootRoutes, required this.rootNavigatorKey})
    : _userRootRoutes = rootRoutes {
    final tabCount = scaffoldRoutes?.children.length ?? 0;
    nestedNavigatorKeys = List.generate(
      tabCount,
      (_) => GlobalKey<NavigatorState>(),
    );
  }

  final PageController pageController = PageController();

  ScaffoldRouteConfig? get scaffoldRoutes {
    final scaffold =
        _userRootRoutes.whereType<ScaffoldRouteConfig>().firstOrNull;
    return scaffold;
  }

  List<RouteConfig> get rootRoutes {
    final routes = _userRootRoutes.whereType<RouteConfig>().toList();

    routes.add(
      RouteConfig(
        path: 'main',
        builder:
            (_) => ScaffoldWithNestedNavigators(
              mainRoutes: scaffoldRoutes?.children,
              navigatorKeys: nestedNavigatorKeys,
              onInitState: scaffoldRoutes?.onInitState,
              onDispose: scaffoldRoutes?.onDispose,
              pageController: pageController,
              pageViewScrollPhysics: scaffoldRoutes?.pageViewScrollPhysics,
              onTapBottomNavBarMode: scaffoldRoutes?.onTapBottomNavBarMode,
            ),
      ),
    );

    return routes;
  }

  GlobalKey<NavigatorState> Function(String route) get navigatorKeyGetter {
    return (String route) {
      if (scaffoldRoutes == null) {
        return rootNavigatorKey;
      }

      for (int i = 0; i < scaffoldRoutes!.children.length; i++) {
        final tabPath = scaffoldRoutes?.children[i].path;
        final key = nestedNavigatorKeys[i];

        if (route == tabPath || route.startsWith('/$tabPath/')) {
          return key;
        }
      }
      return rootNavigatorKey;
    };
  }

  static RouteConfig? findFinalConfig(
    List<String> parts,
    List<RouteConfig> configs,
  ) {
    if (parts.isEmpty) return null;

    for (final config in configs) {
      if (config.path == parts.first) {
        if (parts.length == 1) {
          return config;
        }
        return findFinalConfig(parts.sublist(1), config.children);
      }
    }

    return null;
  }

  static RouteConfig? findRoute(String? name, Set<RouteConfig> configs) {
    final List<String> parts =
        name!
            .split('/')
            .where((part) => part.isNotEmpty)
            // .map((String part) => "/$part")
            .toList();

    return findFinalConfig(parts, configs.toList());
  }

  static Route<dynamic> generateRoutes(
    RouteSettings settings,
    Set<RouteConfig> routes,
    BuildContext context,
  ) {
    final routeConfig = findRoute(settings.name, routes);
    if (routeConfig?.builder != null) {
      final transitionDisabled =
          settings.arguments is Map &&
          (settings.arguments as Map)["pageTransition"] ==
              PageTransition.disabled;

      if (transitionDisabled) {
        final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

        if (isIOS) {
          // return MaterialPageRoute(
          //   builder: (context) => routeConfig!.builder(context),
          //   settings: settings,
          // );
          return CustomPageRouteBuilder(
            builder:
                (context, animation, secondaryAnimation) =>
                    routeConfig!.builder(context),
          );
        } else {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, __, ___) => routeConfig!.builder(context),
            transitionDuration: Duration(seconds: 0),
            reverseTransitionDuration: Duration.zero,
          );
        }
      }

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

  void dispose() {
    pageController.dispose();
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
  final Function(GlobalKey<NavigatorState> navigatorKey)? onInitState;
  final Function()? onDispose;
  final OnTapBottomNavBarMode? onTapBottomNavBarMode;
  final ScrollPhysics? pageViewScrollPhysics;

  const ScaffoldRouteConfig({
    this.children = const [],
    this.bottomNavigationBar,
    this.onInitState,
    this.onDispose,
    this.onTapBottomNavBarMode,
    this.pageViewScrollPhysics,
  });
}

enum PageTransition { enabled, disabled }
