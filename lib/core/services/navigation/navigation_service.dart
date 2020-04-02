import 'package:flutter/material.dart';
import 'package:refresco/core/services/dialog/dialog_service.dart';
import 'package:refresco/locator.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  DialogService dialogService = locator<DialogService>();

  @optionalTypeArgs
  Future<T> navigateTo<T>(String route, {dynamic arguments}) {
    return navigatorKey.currentState.pushNamed<T>(route, arguments: arguments);
  }

  @optionalTypeArgs
  void goBack<T>([T value]) {
    return navigatorKey.currentState.pop<T>(value);
  }

  Future<T> openSearch<T>({@required SearchDelegate<T> delegate}) {
    return showSearch(delegate: delegate, context: navigatorKey.currentContext);
  }
}
