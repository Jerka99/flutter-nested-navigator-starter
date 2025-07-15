import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:untitled/transitions_and_scroll_phisics/custom_page_transition_builder.dart';
import 'app_routes.dart';
import 'app_state.dart';

final store = Store<AppState>(initialState: AppState.initialState());

void main() {
  NavigateAction.setNavigatorKey(AppRoutes.rootNavigatorKey);
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
        navigatorKey: AppRoutes.rootNavigatorKey,
        title: 'Demo',
        initialRoute: AppRoutes.rootRoutes.first.path,
        onGenerateRoute: (settings) {
          if (settings.name == "/") return null;
          return AppRoutes.generateRoutes(settings, AppRoutes.rootRoutes);
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