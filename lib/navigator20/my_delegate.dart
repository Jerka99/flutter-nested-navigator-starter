import 'package:flutter/material.dart';
import 'app_routes_config.dart';

class SimpleRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final RouteService routeService;
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List<String> _pageStack = [];

  SimpleRouterDelegate({required this.routeService}) {
    _pageStack = [
      routeService.initialRoute == "/" ? "root" : routeService.initialRoute,
    ];
  }

  @override
  String get currentConfiguration {
    if (_pageStack.length == 1 && _pageStack[0] == 'root') {
      return '/';
    }
    return '/${_pageStack.join('/')}';
  }

  void push(String route) {
    if (!_isValidRoute(_pageStack.join("/") + route)) return;

    final segments = _splitPath(route.substring(1));
    _pageStack.addAll(segments);
    notifyListeners();
  }

  void pushReplacement(String route) {
    if (!_isValidRoute(route)) return;

    final newSegments = _splitPath(route);
    if (_pageStack.length >= newSegments.length) {
      bool isPrefix = true;
      for (int i = 0; i < newSegments.length; i++) {
        if (_pageStack[i] != newSegments[i]) {
          isPrefix = false;
          break;
        }
      }
      if (isPrefix) {
        // We are currently inside the 'route' subtree, ignore replacement to avoid unwanted pop
        debugPrint(
          "pushReplacement ignored: trying to replace with parent route $route",
        );
        return;
      }
    }

    _pageStack = _splitPath(route);
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
    final List<RouteConfig> routeConfigList = routeService.resolveWidgetStack(
      _pageStack,
    );

    return routeConfigList.isEmpty
        ? SizedBox.shrink()
        : Navigator(
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
    if (configuration.isEmpty) {
      _pageStack = [routeService.initialRoute];
    } else {
      _pageStack = _splitPath(configuration);
    }
    notifyListeners();
  }

  List<String> _splitPath(String path) {
    if (path.isEmpty || path == '/') return ['root'];
    return path.split('/').where((s) => s.isNotEmpty).toList();
  }

  bool _isValidRoute(String route) {
    final cleanRoute = route.startsWith("/") ? route.substring(1) : route;
    final List<String> segments = _splitPath(cleanRoute);
    if (segments.any((s) => s.startsWith(":"))) {
      debugPrint("Rejected route with raw placeholder: $route");
      return false;
    }
    final resolved = routeService.resolveWidgetStack(segments);
    final isValid = resolved.isNotEmpty;

    if (!isValid) {
      debugPrint("Invalid route: $route");
    }

    return isValid;
  }
}
