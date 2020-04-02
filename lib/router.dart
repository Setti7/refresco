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
      return MaterialPageRoute(builder: (context) => BuyView());
    case LoginViewRoute:
      return MaterialPageRoute(builder: (context) => LoginView());
    case AddressViewRoute:
      return MaterialPageRoute(builder: (context) => AddressView());
    case StoreViewRoute:
      return MaterialPageRoute(
        builder: (context) => StoreView(settings.arguments as Store),
      );
    default:
      // TODO: set default route to intro view
      _logger.e('Route "${settings.name}" not found.');
      return MaterialPageRoute(builder: (context) => BuyView());
  }
}
