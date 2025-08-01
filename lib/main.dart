import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:untitled/transitions_and_scroll_phisics/custom_page_transition_builder.dart';
import 'app_state.dart';
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
    final SimpleRouterDelegate _routerDelegate = SimpleRouterDelegate();
    final SimpleRouteParser _routeParser = SimpleRouteParser();
    navigationService.initialize(_routerDelegate.pushReplacement, _routerDelegate.push);

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp.router(
        routerDelegate: _routerDelegate,
        routeInformationParser: _routeParser,
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