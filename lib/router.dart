import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/ui/views/address_view.dart';
import 'package:refresco/ui/views/buy_view.dart';
import 'package:refresco/ui/views/login_view.dart';
import 'package:refresco/ui/views/store_view.dart';
import 'package:refresco/utils/logger.dart';
import 'package:refresco/utils/routing_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var _logger = getLogger('Router');

  switch (settings.name) {
    case BuyViewRoute:
      return _fadeThrough((context) => BuyView());
    case LoginViewRoute:
      return _fadeThrough((context) => LoginView());
    case AddressViewRoute:
      return _sharedAxis(
        (context) => AddressView(),
        SharedAxisTransitionType.vertical,
      );
    case StoreViewRoute:
      return _sharedAxis(
        (context) => StoreView(settings.arguments as Store),
        SharedAxisTransitionType.horizontal,
      );
    default:
      // TODO: set default route to intro view
      _logger.e('Route "${settings.name}" not found.');
      return MaterialPageRoute(builder: (context) => BuyView());
  }
}

Route<T> _fadeThrough<T>(WidgetBuilder page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}

Route<T> _fadeScale<T>(WidgetBuilder page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeScaleTransition(animation: animation, child: child);
    },
  );
}

Route<T> _sharedAxis<T>(WidgetBuilder page,
    [SharedAxisTransitionType type = SharedAxisTransitionType.scaled]) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        child: child,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: type,
      );
    },
  );
}
