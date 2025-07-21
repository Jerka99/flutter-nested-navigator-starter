import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  const CustomPageTransitionBuilder();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      return CupertinoRouteTransitionMixin.buildPageTransitions<T>(
        route,
        context,
        animation,
        secondaryAnimation,
        child,
      );
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
      child: child,
    );
  }
}

class CustomPageTransitionBuilderIOS extends PageTransitionsBuilder {
  final PageTransitionsBuilder matchingBuilder =
  const CupertinoPageTransitionsBuilder();

  const CustomPageTransitionBuilderIOS();

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 0);

  @override
  DelegatedTransitionBuilder? get delegatedTransition =>
      super.delegatedTransition;

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    // Use the CupertinoPageTransitionsBuilder transition animation
    return matchingBuilder.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}


class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({super.parent});

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring =>
      const SpringDescription(mass: 50, stiffness: 100, damping: 0.8);
}


class CustomPageRouteBuilder<T> extends PageRoute<T> {
  final RoutePageBuilder builder;
  final PageTransitionsBuilder matchingBuilder = const CupertinoPageTransitionsBuilder(); // Default iOS/macOS (to get the swipe right to go back gesture)

  CustomPageRouteBuilder({required this.builder});

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context, animation, secondaryAnimation);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 0); // Can give custom Duration, unlike in MaterialPageRoute

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return matchingBuilder.buildTransitions<T>(this, context, animation, secondaryAnimation, child);
  }
}
