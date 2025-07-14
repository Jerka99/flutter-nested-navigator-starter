import 'dart:async';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/services.dart';
import 'package:untitled/profile_connector.dart';
import 'app_state.dart';
import 'home_connector.dart';

final store = Store<AppState>(initialState: AppState.initialState());
final navigatorKey = GlobalKey<NavigatorState>();

final List<GlobalKey<NavigatorState>> navigatorKeys = [
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
];

void main() {
  NavigateAction.setNavigatorKey(navigatorKey);
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
        navigatorKey: navigatorKey,
        title: 'Demo',
        onGenerateRoute: (settings) {
          late Widget page;
          switch (settings.name) {
            case '/':
              page = HomeWidgetConnector();
              break;
            case '/page2':
              page = const BottomNavShell();
              break;
            default:
              page = Scaffold(
                backgroundColor: Colors.yellow,
                body: const Center(child: Text('Unknown Page')),
              );
          }
          return MaterialPageRoute(builder: (_) => page, settings: settings);
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

//---------------------- TRANSITION ----------------------

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  const CustomPageTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> anim,
    Animation<double> secAnim,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
      child: child,
    );
  }
}

class HomeWidget extends StatelessWidget {
  final String? string;
  final Function onPressed;

  const HomeWidget({super.key, required this.onPressed, required this.string});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Home Page", style: TextStyle(fontSize: 32)),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(
                //   context,
                //   rootNavigator: false,
                // ).pushNamed("/page2");
                onPressed();
              },
              child: const Text("Go to /page2"),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  final List<String> tabs = ['/home', '/profile', '/settings'];

  Widget _buildNavigatorPage(int index, String initialRoute) {
    return Container(
      color: Colors.white, // or whatever your scaffold background color is

      child: NavigatorPopHandler(
        onPopWithResult: (_) {
          navigatorKeys[index].currentState?.pop();
        },
        child: Navigator(
          key: navigatorKeys[index],
          initialRoute: initialRoute,
          onGenerateRoute: (RouteSettings settings) {
            if (settings.name == "/") return null;
            Widget child;
            switch (settings.name) {
              case '/profile':
                child = Container(
                  color: Colors.red,
                  child: SingleChildScrollView(
                    child: Text(
                      'Home PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHomeHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome PageHome Page',
                    ),
                  ),
                );
                break;
              case '/home':
                child = ProfileWidgetConnector();
                break;
              case '/settings':
                child = Container(
                  color: Colors.yellow,
                  child: Center(child: Text('Settings Page')),
                );
                break;
              case '/details':
                child = Container(
                  color: Colors.cyan,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Details Page'),
                        TextButton(
                          onPressed: () {
                            NavigateAction.navigatorKey?.currentState?.pop();
                          },
                          child: Text("pop"),
                        ),
                      ],
                    ),
                  ),
                );
                break;
              default:
                child = Center(child: Text('Unknown Pager'));
            }

            return MaterialPageRoute(builder: (_) => child, settings: settings);
          },
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    NavigateAction.setNavigatorKey(navigatorKeys[index]);
    setState(() => _selectedIndex = index);
  }

  void _onTap(int index) {
    // _pageController.animateToPage(
    //   index,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeInOut,
    // );
    NavigateAction.setNavigatorKey(navigatorKeys[index]);
    _pageController.jumpToPage(index);
  }

  @override
  void initState() {
    NavigateAction.setNavigatorKey(navigatorKeys[_selectedIndex]);
    super.initState();
  }

  @override
  void dispose() {
    NavigateAction.setNavigatorKey(navigatorKey);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: CustomPageViewScrollPhysics(),
        //NeverScrollablePhysics
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: tabs.length,
        itemBuilder:
            (context, index) => _buildNavigatorPage(index, tabs[index]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent})
    : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring =>
      const SpringDescription(mass: 50, stiffness: 100, damping: 0.8);
}

class Page2Connector extends StatelessWidget {
  const Page2Connector({super.key});

  @override
  Widget build(BuildContext context) {
    return const Page2();
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.redAccent,
      body: Center(
        child: Text(
          "Page 2 - Home",
          style: TextStyle(fontSize: 32, color: Colors.white),
        ),
      ),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  final Function() onPressed;

  const ProfileWidget({required this.onPressed, super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              // Navigator.of(context, rootNavigator: true).pushNamed("/details");
              widget.onPressed();
            },
            child: Text("button"),
          ),
        ],
      ),
    );
  }
}
