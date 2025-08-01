import 'package:flutter/material.dart';
import 'app_routes_config.dart';

class SimpleRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final String initialRoute = "login";
  List<String> _pageStack = [];

  SimpleRouterDelegate() {
    // Initialize stack with the initial route
    _pageStack = [initialRoute];
  }

  @override
  String get currentConfiguration => _pageStack.join("/").replaceAll('//', '/');

  void push(String route) {
    route = route.substring(1);
    final List<String> segments = _splitPath(route);
    _pageStack.addAll(segments);
    notifyListeners();
  }

  void pushReplacement(String route) {
    route = route.substring(1);
    _pageStack = _splitPath(route);
    if (_pageStack.isEmpty) {
      _pageStack = [initialRoute];
    }
    notifyListeners();
  }

  void pop(String routeName) {
    _pageStack.remove(routeName);
    notifyListeners();
  }

  void popToRoot() {
    if (_pageStack.isNotEmpty) {
      _pageStack = [_pageStack.first];
      notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<RouteConfig> routeConfigList = AppRoutes.resolveWidgetStack(
      _pageStack,
      initialRoute,
    );

    return Navigator(
      key: navigatorKey,
      pages:
          routeConfigList
              .map(
                (RouteConfig routeConfig) => MaterialPage(
                  name: routeConfig.path,
                  child: routeConfig.child,
                  key: ValueKey(routeConfig.child.runtimeType),
                ),
              )
              .toList(),
      onDidRemovePage: (route) {
        pop(route.name!);
        return;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    if (configuration.isEmpty || configuration == initialRoute) {
      _pageStack = [initialRoute];
    } else {
      _pageStack = _splitPath(configuration);
    }
    notifyListeners();
  }

  List<String> _splitPath(String path) {
    return path.split('/').where((s) => s.isNotEmpty).toList();
  }
}
