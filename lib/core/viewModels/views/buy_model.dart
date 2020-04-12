import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/core/services/database/database_service.dart';
import 'package:refresco/core/services/location/location_service.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/utils/logger.dart';

class BuyModel extends BaseModel {
  Logger logger = getLogger('BuyModel');

  // Services
  AuthService authService = locator<AuthService>();
  LocationService locationService = locator<LocationService>();
  DatabaseService dbService = locator<DatabaseService>();

  // Controllers
  RefreshController refreshController = RefreshController();

  List<Store> stores = [];
  String errorMessage;
  String errorTitle;

  BuyModel() {
    locationService.address.listen((address) {
      logger.d('address changed: getting new stores');
      getStores(address: address);
    });
  }

  Future<void> getStores({
    @required Address address,
    bool force = false,
  }) async {
    if (!force) setState(ViewState.busy);

    errorTitle = null;
    errorMessage = null;

    final response = await dbService.getStores(address);

    if (response.success) {
      stores = response.results;
    } else {
      errorTitle = 'Opa :(';
      errorMessage = response.errorMessage;
    }

    setState(ViewState.idle);
  }

  Future<void> onRefresh({
    @required Address address,
  }) async {
    await getStores(
      address: address,
      force: true,
    );

    refreshController.refreshCompleted();
  }

  void logout() => authService.logout();
}
