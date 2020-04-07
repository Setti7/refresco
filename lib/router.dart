import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/ui/views/address_view.dart';
import 'package:refresco/ui/views/buy_view.dart';
import 'package:refresco/ui/views/login_view.dart';
import 'package:refresco/ui/views/payment_method_view.dart';
import 'package:refresco/ui/views/store_view.dart';
import 'package:refresco/utils/logger.dart';
import 'package:refresco/utils/routing_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var _logger = getLogger('Router');
  String routeName = settings.name;

  if (routeName == Router.BuyViewRoute) {
    return _fadeThrough((context) => BuyView());
  } else if (routeName == Router.LoginViewRoute) {
    return _fadeThrough((context) => LoginView());
  } else if (routeName == Router.AddressViewRoute) {
    return _sharedAxis(
      (context) => AddressView(),
      SharedAxisTransitionType.vertical,
    );
  } else if (routeName == Router.StoreViewRoute) {
    return _sharedAxis(
      (context) => StoreView(settings.arguments as Store),
      SharedAxisTransitionType.horizontal,
    );
  } else if (routeName == Router.PaymentMethodViewRoute) {
    return _sharedAxis(
      (context) => PaymentMethodView(settings.arguments as Cart),
      SharedAxisTransitionType.horizontal,
    );
  } else {
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

//Route<T> _fadeScale<T>(WidgetBuilder page) {
//  return PageRouteBuilder<T>(
//    pageBuilder: (context, animation, secondaryAnimation) => page(context),
//    transitionsBuilder: (context, animation, secondaryAnimation, child) {
//      return FadeScaleTransition(animation: animation, child: child);
//    },
//  );
//}

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
