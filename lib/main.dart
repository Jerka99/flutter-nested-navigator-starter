import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:untitled/navigator20/route_definitions.dart';
import 'package:untitled/transitions_and_scroll_phisics/custom_page_transition_builder.dart';
import 'app_state.dart';
import 'navigator20/app_routes_config.dart';
import 'navigator20/my_delegate.dart';
import 'navigator20/my_info_parser.dart';
import 'navigator20/navigation_service.dart';

final store = Store<AppState>(initialState: AppState.initialState());
final rootNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp(store: store));
}

final NavigationService navigationService = NavigationService();

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    RouteService routeService = RouteService(
      securedRoutes: securedRoutes,
      unsecuredRoutes: unsecuredRoutes,
      loggedIn: true,
    );
    final SimpleRouterDelegate routerDelegate = SimpleRouterDelegate(
      routeService: routeService,
    );
    final SimpleRouteParser routeParser = SimpleRouteParser();
    navigationService.initialize(
      routerDelegate.pushReplacement,
      routerDelegate.push,
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp.router(
        routerDelegate: routerDelegate,
        routeInformationParser: routeParser,
        title: 'Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilderIOS(),
            },
          ),
        ),
      ),
    );
  }
}
