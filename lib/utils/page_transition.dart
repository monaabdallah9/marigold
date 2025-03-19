import 'package:flutter/material.dart';

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  @override
  final RouteSettings settings;
  final String transitionType;

  CustomPageRoute({
    required this.child,
    required this.settings,
    this.transitionType = 'fade',
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset.zero;
            var end = Offset.zero;
            var curve = Curves.easeInOutCubic;
            var tween = Tween(begin: begin, end: end);

            switch (transitionType) {
              case 'slide_right':
                begin = const Offset(-1.0, 0.0);
                end = Offset.zero;
                break;
              case 'slide_left':
                begin = const Offset(1.0, 0.0);
                end = Offset.zero;
                break;
              case 'slide_up':
                begin = const Offset(0.0, 1.0);
                end = Offset.zero;
                break;
              case 'slide_down':
                begin = const Offset(0.0, -1.0);
                end = Offset.zero;
                break;
              case 'scale':
                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: curve,
                  ),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              case 'rotate':
                return RotationTransition(
                  turns: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                );
              default: // fade
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
            }

            var offsetAnimation = animation.drive(tween.chain(
              CurveTween(curve: curve),
            ));

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          settings: settings,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
}

extension NavigatorExtension on BuildContext {
  Future<T?> pushWithTransition<T extends Object?>(
    Widget page, {
    String transitionType = 'fade',
  }) {
    return Navigator.push<T>(
      this,
      CustomPageRoute<T>(
        child: page,
        transitionType: transitionType,
        settings: const RouteSettings(),
      ),
    );
  }

  Future<T?> pushReplacementWithTransition<T extends Object?, TO extends Object?>(
    Widget page, {
    String transitionType = 'fade',
    TO? result,
  }) {
    return Navigator.pushReplacement<T, TO>(
      this,
      CustomPageRoute<T>(
        child: page,
        transitionType: transitionType,
        settings: const RouteSettings(),
      ),
      result: result,
    );
  }
} 