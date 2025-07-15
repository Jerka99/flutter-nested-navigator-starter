import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:untitled/transitions_and_scroll_phisics/custom_page_transition_builder.dart';

import 'app_routes.dart';
import 'main.dart';

class ScaffoldWithNestedNavigators extends StatefulWidget {
  final List<RouteConfig>? mainRoutes;
  final List<GlobalKey<NavigatorState>> navigatorKeys;
  final Widget? bottomNavigationBar;

  const ScaffoldWithNestedNavigators({
    super.key,
    this.mainRoutes,
    required this.navigatorKeys,
    this.bottomNavigationBar,
  });

  @override
  State<ScaffoldWithNestedNavigators> createState() =>
      _ScaffoldWithNestedNavigatorsState();
}

class _ScaffoldWithNestedNavigatorsState
    extends State<ScaffoldWithNestedNavigators> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  late Map<String, IconData>? tabNamesAndIcons;
  late final List<String> tabRoutes;
  late final List<WidgetBuilder> tabBuilders;

  @override
  void initState() {
    tabRoutes =
        widget.mainRoutes!.map((mainRoutes) => mainRoutes.path).toList();
    tabBuilders =
        widget.mainRoutes!.map((mainRoutes) => mainRoutes.builder).toList();

    tabNamesAndIcons = {
      for (final mainRoute in widget.mainRoutes!)
        if (mainRoute.icon != null) mainRoute.path: mainRoute.icon!,
    };
    NavigateAction.setNavigatorKey(widget.navigatorKeys[_selectedIndex]);
    super.initState();
  }

  String _formatRouteName(String route) {
    final name = route.startsWith('/') ? route.substring(1) : route;
    return name.isNotEmpty ? name[0].toUpperCase() + name.substring(1) : '';
  }

  @override
  void dispose() {
    NavigateAction.setNavigatorKey(appRoutes.rootNavigatorKey);
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildNavigatorPage(int index, String initialRoute) {
    return Container(
      color: Colors.white,

      child: NavigatorPopHandler(
        onPopWithResult: (_) {
          widget.navigatorKeys[index].currentState?.pop();
        },
        child: Navigator(
          key: widget.navigatorKeys[index],
          initialRoute: initialRoute,
          onGenerateRoute: (RouteSettings settings) {
            if (settings.name == "/") return null;
            return AppRoutes.generateRoutes(
              settings,
              widget.mainRoutes!.toSet(),
            );
          },
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    // NavigateAction.setNavigatorKey(widget.navigatorKeys[index]);
    setState(() => _selectedIndex = index);
  }

  void _onTap(int index) {
    // NavigateAction.setNavigatorKey(widget.navigatorKeys[index]);
    // _pageController.animateToPage(
    //   index,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeInOut,
    // );
    // store.dispatch(
    //   CustomNavigateAction.pushReplacementNamed(
    //     '/profile',
    //     widget.navigatorKeys[2],
    //   ),
    // );
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: CustomPageViewScrollPhysics(),
        //NeverScrollablePhysics
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: tabNamesAndIcons?.length,
        itemBuilder:
            (context, index) => _buildNavigatorPage(
              index,
              tabNamesAndIcons!.keys.toList()[index],
            ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        items: [
          ...?tabNamesAndIcons?.entries.map(
            (entry) => BottomNavigationBarItem(
              label: _formatRouteName(entry.key),
              icon: Icon(entry.value),
            ),
          ),
        ],
      ),
    );
  }
}
