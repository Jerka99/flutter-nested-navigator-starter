import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'app_routes.dart';
import 'main.dart';

class ScaffoldWithNestedNavigators extends StatefulWidget {
  final List<RouteConfig>? mainRoutes;
  final List<GlobalKey<NavigatorState>> navigatorKeys;
  final Widget? bottomNavigationBar;
  final Function(GlobalKey<NavigatorState> navigatorKey)? onInitState;
  final Function()? onDispose;
  final PageController pageController;
  final OnTapBottomNavBarMode onTapBottomNavBarMode;
  final ScrollPhysics pageViewScrollPhysics;

  const ScaffoldWithNestedNavigators({
    super.key,
    this.mainRoutes,
    required this.navigatorKeys,
    this.bottomNavigationBar,
    this.onInitState,
    this.onDispose,
    required this.pageController,
    OnTapBottomNavBarMode? onTapBottomNavBarMode,
    ScrollPhysics? pageViewScrollPhysics,
  }) : onTapBottomNavBarMode =
           onTapBottomNavBarMode ?? OnTapBottomNavBarMode.jumpToPage,
       pageViewScrollPhysics =
           pageViewScrollPhysics ?? const NeverScrollableScrollPhysics();

  @override
  State<ScaffoldWithNestedNavigators> createState() =>
      _ScaffoldWithNestedNavigatorsState();
}

class _ScaffoldWithNestedNavigatorsState
    extends State<ScaffoldWithNestedNavigators> {
  late final PageController _pageController;
  int _selectedIndex = 0;
  late Map<String, IconData>? tabNamesAndIcons;
  late final List<WidgetBuilder> tabBuilders;

  @override
  void initState() {
    tabBuilders =
        widget.mainRoutes!.map((mainRoutes) => mainRoutes.builder).toList();

    tabNamesAndIcons = {
      for (final mainRoute in widget.mainRoutes!)
        if (mainRoute.icon != null) mainRoute.path: mainRoute.icon!,
    };
    if (widget.onInitState != null) {
      widget.onInitState!(widget.navigatorKeys[_selectedIndex]);
    }
    _pageController = widget.pageController;
    super.initState();
  }

  String _formatRouteName(String route) {
    final name = route.startsWith('/') ? route.substring(1) : route;
    return name.isNotEmpty ? name[0].toUpperCase() + name.substring(1) : '';
  }

  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose!();
    }
    super.dispose();
  }

  Widget _buildNavigatorPage(int index, String initialRoute) {
    return VisibilityDetector(
      key: Key('tab-$index'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0.0) {
          widget.navigatorKeys[index].currentState?.popUntil(
            (route) =>
                route.settings.name ==
                appRoutes.scaffoldRoutes?.children[index].path,
          );
        } else {
          // print(
          //   'Tab $index is now visible (${(info.visibleFraction * 100).round()}%)',
          // );
        }
      },
      child: NavigatorPopHandler(
        onPopWithResult: (_) {
          widget.navigatorKeys[index].currentState?.maybePop();
        },
        child: Navigator(
          key: widget.navigatorKeys[index],
          initialRoute: initialRoute,
          onGenerateRoute: (RouteSettings settings) {
            return AppRoutes.generateRoutes(
              settings,
              widget.mainRoutes!.toSet(),
              context
            );
          },
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onTap(int index) {
    switch (widget.onTapBottomNavBarMode) {
      case OnTapBottomNavBarMode.animateToPage:
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      case OnTapBottomNavBarMode.jumpToPage:
        _pageController.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        // physics: widget.pageViewScrollPhysics,
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: tabNamesAndIcons?.length,
        itemBuilder: (context, index) {
          final routeName = tabNamesAndIcons!.keys.toList()[index];
          return KeepAliveWrapper(child: _buildNavigatorPage(index, routeName));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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

enum OnTapBottomNavBarMode { animateToPage, jumpToPage }

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
