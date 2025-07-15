import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:untitled/pages/details_page.dart';
import 'package:untitled/pages/first_page.dart';
import 'package:untitled/transitions_and_scroll_phisics/custom_page_transition_builder.dart';
import 'app_routes.dart';
import 'app_state.dart';
import 'async_redux/connectors/login_page_connector.dart';
import 'async_redux/connectors/page_2_connector.dart';
import 'async_redux/connectors/profile_connector.dart';

final store = Store<AppState>(initialState: AppState.initialState());
final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRoutes = AppRoutes(
  rootRoutes: [
    RouteConfig(path: '/login', builder: (_) => LoginPageConnector()),
    ScaffoldRouteConfig(
      children: <RouteConfig>[
        RouteConfig(
          path: '/home',
          builder: (_) => FirstPage(),
          icon: Icons.home,
        ),
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
            RouteConfig(
              path: '/profile/details',
              builder: (_) => DetailsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
  rootNavigatorKey: rootNavigatorKey,
);

void main() {
  NavigateAction.setNavigatorKey(rootNavigatorKey);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        navigatorKey: rootNavigatorKey,
        title: 'Demo',
        initialRoute: appRoutes.rootRoutes.first.path,
        onGenerateRoute: (settings) {
          if (settings.name == "/") return null;
          return AppRoutes.generateRoutes(
            settings,
            appRoutes.rootRoutes.toSet(),
          );
        },
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            },
          ),
        ),
      ),
    );
  }
}
